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
      appBar: AppBar(title: const Row(mainAxisSize: MainAxisSize.min, children: [
        Text('OPEN', style: TextStyle(color: QuestTheme.neonPink, letterSpacing: 2)),
        Text('QUEST', style: TextStyle(color: QuestTheme.neonBlue, letterSpacing: 2)),
      ])),
      body: trees.isEmpty
        ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.grid_4x4, size: 64, color: Colors.white12),
            SizedBox(height: 16),
            Text('NEON GRID EMPTY', style: TextStyle(color: Colors.white24, letterSpacing: 1.2)),
          ]))
        : ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: trees.length,
            itemBuilder: (_, i) {
              final tree = trees[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: QuestTheme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: const Icon(Icons.hub_outlined, color: QuestTheme.neonBlue),
                  title: Text(tree.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('${tree.nodes.length} NODES // ${tree.edges.length} EDGES', 
                    style: const TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.1)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white24), 
                    onPressed: () => ref.read(questProvider.notifier).deleteTree(tree.id)
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CanvasScreen(treeId: tree.id))),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final ctrl = TextEditingController();
          showDialog(context: context, builder: (_) => AlertDialog(
            backgroundColor: QuestTheme.card,
            title: const Text('NEW PROJECT'),
            content: TextField(
              controller: ctrl, 
              autofocus: true, 
              decoration: const InputDecoration(labelText: 'Project Name'),
              style: const TextStyle(color: Colors.white)
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white38))),
              TextButton(
                onPressed: () { 
                  if (ctrl.text.trim().isNotEmpty) { 
                    ref.read(questProvider.notifier).addTree(ctrl.text.trim()); 
                    Navigator.pop(context); 
                  } 
                }, 
                child: const Text('INITIALIZE', style: TextStyle(color: QuestTheme.neonPink, fontWeight: FontWeight.bold))
              ),
            ],
          ));
        },
        label: const Text('INITIALIZE GRID'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
