import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/quest_models.dart';

const _uuid = Uuid();

class QuestProjectNotifier extends StateNotifier<List<QuestTree>> {
  final Box _box;
  QuestProjectNotifier(this._box) : super([]) { _load(); }

  void _load() {
    final raw = _box.get('trees', defaultValue: '[]') as String;
    state = (jsonDecode(raw) as List).map((e) => QuestTree.fromJson(e as Map<String, dynamic>)).toList();
  }
  void _save() => _box.put('trees', jsonEncode(state.map((t) => t.toJson()).toList()));

  void addTree(String name) {
    final tree = QuestTree(id: _uuid.v4(), name: name, nodes: [
      QuestNode(id: _uuid.v4(), type: NodeType.start, title: 'Start', x: 200, y: 50),
    ]);
    state = [...state, tree];
    _save();
  }

  void deleteTree(String id) { state = state.where((t) => t.id != id).toList(); _save(); }

  void addNode(String treeId, NodeType type, double x, double y) {
    state = state.map((t) {
      if (t.id != treeId) return t;
      final node = QuestNode(id: _uuid.v4(), type: type, title: type.label, x: x, y: y);
      return QuestTree(id: t.id, name: t.name, nodes: [...t.nodes, node], edges: t.edges, variables: t.variables);
    }).toList();
    _save();
  }

  void updateNode(String treeId, QuestNode updated) {
    state = state.map((t) {
      if (t.id != treeId) return t;
      return QuestTree(id: t.id, name: t.name,
        nodes: t.nodes.map((n) => n.id == updated.id ? updated : n).toList(),
        edges: t.edges, variables: t.variables);
    }).toList();
    _save();
  }

  void moveNode(String treeId, String nodeId, double x, double y) {
    state = state.map((t) {
      if (t.id != treeId) return t;
      return QuestTree(id: t.id, name: t.name,
        nodes: t.nodes.map((n) { if (n.id == nodeId) { n.x = x; n.y = y; } return n; }).toList(),
        edges: t.edges, variables: t.variables);
    }).toList();
    _save();
  }

  void deleteNode(String treeId, String nodeId) {
    state = state.map((t) {
      if (t.id != treeId) return t;
      return QuestTree(id: t.id, name: t.name,
        nodes: t.nodes.where((n) => n.id != nodeId).toList(),
        edges: t.edges.where((e) => e.fromNodeId != nodeId && e.toNodeId != nodeId).toList(),
        variables: t.variables);
    }).toList();
    _save();
  }

  void addEdge(String treeId, String fromId, String toId) {
    state = state.map((t) {
      if (t.id != treeId) return t;
      final exists = t.edges.any((e) => e.fromNodeId == fromId && e.toNodeId == toId);
      if (exists) return t;
      final edge = QuestEdge(id: _uuid.v4(), fromNodeId: fromId, toNodeId: toId);
      return QuestTree(id: t.id, name: t.name, nodes: t.nodes, edges: [...t.edges, edge], variables: t.variables);
    }).toList();
    _save();
  }

  void deleteEdge(String treeId, String edgeId) {
    state = state.map((t) {
      if (t.id != treeId) return t;
      return QuestTree(id: t.id, name: t.name, nodes: t.nodes,
        edges: t.edges.where((e) => e.id != edgeId).toList(), variables: t.variables);
    }).toList();
    _save();
  }

  String exportJson(String treeId) {
    final tree = state.firstWhere((t) => t.id == treeId);
    return const JsonEncoder.withIndent('  ').convert(tree.toJson());
  }
}

final questBoxProvider = FutureProvider<Box>((ref) => Hive.openBox('open_quest'));

final questProvider = StateNotifierProvider<QuestProjectNotifier, List<QuestTree>>((ref) {
  final box = ref.watch(questBoxProvider);
  return box.when(data: (b) => QuestProjectNotifier(b), loading: () => QuestProjectNotifier(Hive.box('open_quest')), error: (_, __) => QuestProjectNotifier(Hive.box('open_quest')));
});

final activeTreeProvider = StateProvider<String?>((ref) => null);
final selectedNodeProvider = StateProvider<String?>((ref) => null);
final connectingFromProvider = StateProvider<String?>((ref) => null);
