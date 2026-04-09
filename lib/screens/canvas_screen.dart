import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest_models.dart';
import '../providers/quest_providers.dart';
import '../widgets/quest_node_widget.dart';
import '../widgets/edge_painter.dart';
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
          IconButton(icon: const Icon(Icons.code), onPressed: () {
            final json = notifier.exportJson(treeId);
            showDialog(context: context, builder: (_) => AlertDialog(
              backgroundColor: QuestTheme.card,
              title: const Text('Export JSON'),
              content: SizedBox(width: 400, child: SingleChildScrollView(
                child: SelectableText(json, style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.white70)),
              )),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
            ));
          }),
        ],
      ),
      body: InteractiveViewer(
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
