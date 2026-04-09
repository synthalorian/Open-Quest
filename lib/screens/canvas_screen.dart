import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest_models.dart';
import '../providers/quest_providers.dart';
import '../widgets/quest_node_widget.dart';
import '../widgets/edge_painter.dart';
import '../widgets/node_editor.dart';
import '../theme/quest_theme.dart';

class CanvasScreen extends ConsumerWidget {
  final String treeId;
  const CanvasScreen({super.key, required this.treeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trees = ref.watch(questProvider);
    final tree = trees.where((t) => t.id == treeId).firstOrNull;
    if (tree == null) return const Scaffold(body: Center(child: Text('Tree not found')));

    final selectedId = ref.watch(selectedNodeProvider);
    final connectingFrom = ref.watch(connectingFromProvider);
    final notifier = ref.read(questProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(tree.name),
        actions: [
          IconButton(
            tooltip: 'Project Variables',
            icon: const Icon(Icons.settings_input_component),
            onPressed: () {
              // Variable Editor Dialog
              showDialog(context: context, builder: (_) => _VariableEditorDialog(treeId: treeId));
            },
          ),
          IconButton(
            tooltip: 'Export JSON',
            icon: const Icon(Icons.code), 
            onPressed: () {
            final json = notifier.exportJson(treeId);
            showDialog(context: context, builder: (_) => AlertDialog(
              backgroundColor: QuestTheme.card,
              title: const Text('Export JSON'),
              content: SizedBox(width: 400, child: SingleChildScrollView(
                child: SelectableText(json, style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.white70)),
              )),
              actions: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: json));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard!')));
                  },
                  child: const Text('Copy'),
                ),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
              ],
            ));
          }),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(500),
              minScale: 0.3,
              maxScale: 3.0,
              child: SizedBox(
                width: 2000, height: 2000,
                child: Stack(children: [
                  CustomPaint(
                    size: const Size(2000, 2000),
                    painter: EdgePainter(nodes: tree.nodes, edges: tree.edges),
                  ),
                  ...tree.nodes.map((node) => Positioned(
                    left: node.x, top: node.y,
                    child: QuestNodeWidget(
                      node: node,
                      isSelected: node.id == selectedId,
                      isConnecting: connectingFrom != null,
                      onTap: () {
                        if (connectingFrom != null && connectingFrom != node.id) {
                          notifier.addEdge(treeId, connectingFrom, node.id);
                          ref.read(connectingFromProvider.notifier).state = null;
                        } else {
                          ref.read(selectedNodeProvider.notifier).state = node.id == selectedId ? null : node.id;
                        }
                      },
                      onDragEnd: (dx, dy) => notifier.moveNode(treeId, node.id, node.x + dx, node.y + dy),
                      onConnect: () => ref.read(connectingFromProvider.notifier).state = node.id,
                      onDelete: () => notifier.deleteNode(treeId, node.id),
                    ),
                  )),
                ]),
              ),
            ),
          ),
          if (selectedId != null) NodeEditor(treeId: treeId, nodeId: selectedId),
        ],
      ),
      floatingActionButton: Column(mainAxisSize: MainAxisSize.min, children: [
        for (final type in NodeType.values.where((t) => t != NodeType.start))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FloatingActionButton.small(
              heroTag: type.name,
              backgroundColor: type.color,
              onPressed: () => notifier.addNode(treeId, type, 200 + (tree.nodes.length * 30.0) % 400, 200 + (tree.nodes.length * 50.0) % 300),
              child: Text(type.label[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
      ]),
    );
  }
}

class _VariableEditorDialog extends ConsumerStatefulWidget {
  final String treeId;
  const _VariableEditorDialog({required this.treeId});

  @override
  ConsumerState<_VariableEditorDialog> createState() => _VariableEditorDialogState();
}

class _VariableEditorDialogState extends ConsumerState<_VariableEditorDialog> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    final trees = ref.read(questProvider);
    final tree = trees.firstWhere((t) => t.id == widget.treeId);
    tree.variables.forEach((k, v) {
      _controllers[k] = TextEditingController(text: v);
    });
  }

  void _save() {
    final vars = <String, String>{};
    _controllers.forEach((k, v) {
      vars[k] = v.text;
    });
    ref.read(questProvider.notifier).updateVariables(widget.treeId, vars);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: QuestTheme.card,
      title: const Text('PROJECT VARIABLES'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_controllers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('No variables defined', style: TextStyle(color: Colors.white24)),
              ),
            ..._controllers.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(child: Text(entry.key, style: const TextStyle(fontSize: 12))),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: entry.value,
                      decoration: const InputDecoration(isDense: true),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 16),
                    onPressed: () => setState(() => _controllers.remove(entry.key)),
                  ),
                ],
              ),
            )),
            const Divider(),
            TextButton.icon(
              onPressed: () {
                final keyCtrl = TextEditingController();
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Variable Key'),
                    content: TextField(controller: keyCtrl, autofocus: true),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          if (keyCtrl.text.isNotEmpty) {
                            setState(() => _controllers[keyCtrl.text] = TextEditingController());
                          }
                          Navigator.pop(ctx);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Variable'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            _save();
            Navigator.pop(context);
          },
          child: const Text('SAVE', style: TextStyle(color: QuestTheme.neonPink, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}
