import 'package:flutter/material.dart';
import '../models/quest_models.dart';

class EdgePainter extends CustomPainter {
  final List<QuestNode> nodes;
  final List<QuestEdge> edges;

  EdgePainter({required this.nodes, required this.edges});

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in edges) {
      final from = nodes.where((n) => n.id == edge.fromNodeId).firstOrNull;
      final to = nodes.where((n) => n.id == edge.toNodeId).firstOrNull;
      if (from == null || to == null) continue;

      final start = Offset(from.x + 80, from.y + 30);
      final end = Offset(to.x + 80, to.y + 30);

      final paint = Paint()..color = Colors.white38..strokeWidth = 2..style = PaintingStyle.stroke;
      final path = Path()..moveTo(start.dx, start.dy);
      final midY = (start.dy + end.dy) / 2;
      path.cubicTo(start.dx, midY, end.dx, midY, end.dx, end.dy);
      canvas.drawPath(path, paint);

      // Arrowhead
      final dir = (end - Offset(end.dx, midY)).direction;
      final arrowPaint = Paint()..color = Colors.white38..style = PaintingStyle.fill;
      final arrowPath = Path();
      arrowPath.moveTo(end.dx, end.dy);
      arrowPath.lineTo(end.dx - 8 * (end.dx > start.dx ? 1 : -1), end.dy - 8);
      arrowPath.lineTo(end.dx + 8 * (end.dx > start.dx ? 1 : -1), end.dy - 8);
      arrowPath.close();
      canvas.drawPath(arrowPath, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant EdgePainter old) => true;
}
