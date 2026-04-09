import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quest_providers.dart';
import '../theme/quest_theme.dart';
import 'canvas_screen.dart';

class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trees = ref.watch(questProvider);

    return Scaffold(
      appBar: AppBar(title: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('Open', style: TextStyle(color: QuestTheme.green)),
        const Text('Quest'),
      ])),
      body: trees.isEmpty
        ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.account_tree, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            const Text('No quest trees yet', style: TextStyle(color: Colors.white38)),
          ]))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trees.length,
            itemBuilder: (_, i) {
              final tree = trees[i];
              return Card(
                color: QuestTheme.card,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(Icons.account_tree, color: QuestTheme.green),
                  title: Text(tree.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${tree.nodes.length} nodes, ${tree.edges.length} edges', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.white24), onPressed: () => ref.read(questProvider.notifier).deleteTree(tree.id)),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CanvasScreen(treeId: tree.id))),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final ctrl = TextEditingController();
          showDialog(context: context, builder: (_) => AlertDialog(
            backgroundColor: QuestTheme.card,
            title: const Text('New Quest Tree'),
            content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(hintText: 'Name...'), style: const TextStyle(color: Colors.white)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(onPressed: () { if (ctrl.text.trim().isNotEmpty) { ref.read(questProvider.notifier).addTree(ctrl.text.trim()); Navigator.pop(context); } }, child: Text('Create', style: TextStyle(color: QuestTheme.green))),
            ],
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
