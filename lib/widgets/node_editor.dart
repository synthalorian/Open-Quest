import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest_models.dart';
import '../providers/quest_providers.dart';
import '../theme/quest_theme.dart';

class NodeEditor extends ConsumerStatefulWidget {
  final String treeId;
  final String nodeId;
  const NodeEditor({super.key, required this.treeId, required this.nodeId});

  @override
  ConsumerState<NodeEditor> createState() => _NodeEditorState();
}

class _NodeEditorState extends ConsumerState<NodeEditor> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final Map<String, TextEditingController> _propControllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final trees = ref.read(questProvider);
    final tree = trees.firstWhere((t) => t.id == widget.treeId);
    final node = tree.nodes.firstWhere((n) => n.id == widget.nodeId);
    
    _titleController = TextEditingController(text: node.title);
    _contentController = TextEditingController(text: node.content);
    _propControllers.clear();
    node.properties.forEach((k, v) {
      _propControllers[k] = TextEditingController(text: v);
    });
  }

  @override
  void didUpdateWidget(NodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.nodeId != widget.nodeId) {
      _initControllers();
    }
  }

  void _save() {
    final trees = ref.read(questProvider);
    final tree = trees.firstWhere((t) => t.id == widget.treeId);
    final node = tree.nodes.firstWhere((n) => n.id == widget.nodeId);

    final updatedProperties = <String, String>{};
    _propControllers.forEach((k, v) {
      updatedProperties[k] = v.text;
    });

    final updatedNode = QuestNode(
      id: node.id,
      type: node.type,
      title: _titleController.text,
      content: _contentController.text,
      x: node.x,
      y: node.y,
      properties: updatedProperties,
    );

    ref.read(questProvider.notifier).updateNode(widget.treeId, updatedNode);
  }

  @override
  Widget build(BuildContext context) {
    final trees = ref.watch(questProvider);
    final tree = trees.where((t) => t.id == widget.treeId).firstOrNull;
    final node = tree?.nodes.where((n) => n.id == widget.nodeId).firstOrNull;

    if (node == null) return const SizedBox.shrink();

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: QuestTheme.background.withOpacity(0.9),
        border: const Border(left: BorderSide(color: Colors.white12)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: node.type.color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  node.type.label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => ref.read(selectedNodeProvider.notifier).state = null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            onChanged: (_) => _save(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
            onChanged: (_) => _save(),
          ),
          const SizedBox(height: 24),
          const Text('PROPERTIES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                ..._propControllers.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(entry.key, style: const TextStyle(fontSize: 12, color: Colors.white70))),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: entry.value,
                          decoration: const InputDecoration(isDense: true, border: UnderlineInputBorder()),
                          style: const TextStyle(fontSize: 12),
                          onChanged: (_) => _save(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 16),
                        onPressed: () {
                          setState(() => _propControllers.remove(entry.key));
                          _save();
                        },
                      ),
                    ],
                  ),
                )),
                TextButton.icon(
                  onPressed: () {
                    final keyController = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('New Property Key'),
                        content: TextField(controller: keyController, autofocus: true),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              if (keyController.text.isNotEmpty) {
                                setState(() => _propControllers[keyController.text] = TextEditingController());
                                _save();
                              }
                              Navigator.pop(ctx);
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Property'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    for (var c in _propControllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}
