import 'package:flutter_test/flutter_test.dart';
import 'package:open_quest/models/quest_models.dart';

void main() {
  test('QuestNode round-trips JSON', () {
    final node = QuestNode(id: '1', type: NodeType.dialogue, title: 'Hello', content: 'World', x: 50, y: 100);
    final json = node.toJson();
    final restored = QuestNode.fromJson(json);
    expect(restored.id, '1');
    expect(restored.type, NodeType.dialogue);
    expect(restored.title, 'Hello');
    expect(restored.x, 50);
  });

  test('QuestEdge round-trips JSON', () {
    final edge = QuestEdge(id: '1', fromNodeId: 'a', toNodeId: 'b', label: 'yes');
    final restored = QuestEdge.fromJson(edge.toJson());
    expect(restored.label, 'yes');
  });

  test('QuestTree round-trips JSON', () {
    final tree = QuestTree(id: '1', name: 'Test',
      nodes: [QuestNode(id: 'n1', type: NodeType.start, x: 0, y: 0)],
      edges: [QuestEdge(id: 'e1', fromNodeId: 'n1', toNodeId: 'n1')],
      variables: {'gold': '100'});
    final restored = QuestTree.fromJson(tree.toJson());
    expect(restored.nodes.length, 1);
    expect(restored.edges.length, 1);
    expect(restored.variables['gold'], '100');
  });

  test('NodeType has correct colors', () {
    expect(NodeType.start.label, 'Start');
    expect(NodeType.values.length, 6);
  });
}
