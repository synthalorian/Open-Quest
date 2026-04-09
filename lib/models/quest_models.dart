import 'dart:ui';

enum NodeType {
  start('Start', Color(0xFF4CAF50)),
  dialogue('Dialogue', Color(0xFF2196F3)),
  choice('Choice', Color(0xFFFF9800)),
  condition('Condition', Color(0xFF9C27B0)),
  action('Action', Color(0xFFE91E63)),
  end('End', Color(0xFF607D8B));

  final String label;
  final Color color;
  const NodeType(this.label, this.color);
}

class QuestNode {
  final String id;
  final NodeType type;
  String title;
  String content;
  double x;
  double y;
  Map<String, String> properties;

  QuestNode({
    required this.id,
    required this.type,
    this.title = '',
    this.content = '',
    this.x = 100,
    this.y = 100,
    Map<String, String>? properties,
  }) : properties = properties ?? {};

  Map<String, dynamic> toJson() => {
    'id': id, 'type': type.name, 'title': title, 'content': content,
    'x': x, 'y': y, 'properties': properties,
  };

  factory QuestNode.fromJson(Map<String, dynamic> j) => QuestNode(
    id: j['id'] as String,
    type: NodeType.values.firstWhere((t) => t.name == j['type']),
    title: j['title'] as String? ?? '',
    content: j['content'] as String? ?? '',
    x: (j['x'] as num).toDouble(),
    y: (j['y'] as num).toDouble(),
    properties: Map<String, String>.from(j['properties'] as Map? ?? {}),
  );
}

class QuestEdge {
  final String id;
  final String fromNodeId;
  final String toNodeId;
  String label;

  QuestEdge({required this.id, required this.fromNodeId, required this.toNodeId, this.label = ''});

  Map<String, dynamic> toJson() => {'id': id, 'fromNodeId': fromNodeId, 'toNodeId': toNodeId, 'label': label};

  factory QuestEdge.fromJson(Map<String, dynamic> j) => QuestEdge(
    id: j['id'] as String, fromNodeId: j['fromNodeId'] as String,
    toNodeId: j['toNodeId'] as String, label: j['label'] as String? ?? '',
  );
}

class QuestTree {
  final String id;
  String name;
  List<QuestNode> nodes;
  List<QuestEdge> edges;
  Map<String, String> variables;

  QuestTree({required this.id, required this.name, List<QuestNode>? nodes, List<QuestEdge>? edges, Map<String, String>? variables})
    : nodes = nodes ?? [], edges = edges ?? [], variables = variables ?? {};

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name,
    'nodes': nodes.map((n) => n.toJson()).toList(),
    'edges': edges.map((e) => e.toJson()).toList(),
    'variables': variables,
  };

  factory QuestTree.fromJson(Map<String, dynamic> j) => QuestTree(
    id: j['id'] as String, name: j['name'] as String,
    nodes: (j['nodes'] as List?)?.map((n) => QuestNode.fromJson(n as Map<String, dynamic>)).toList(),
    edges: (j['edges'] as List?)?.map((e) => QuestEdge.fromJson(e as Map<String, dynamic>)).toList(),
    variables: Map<String, String>.from(j['variables'] as Map? ?? {}),
  );
}
