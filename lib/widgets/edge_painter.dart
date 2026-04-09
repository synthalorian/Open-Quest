import 'package:flutter/material.dart';
import '../models/quest_models.dart';
import '../theme/quest_theme.dart';

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

      final start = Offset(from.x + 160, from.y + 40); // Right side
      final end = Offset(to.x, to.y + 40); // Left side

      final paint = Paint()
        ..color = QuestTheme.neonBlue.withOpacity(0.5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final path = Path()..moveTo(start.dx, start.dy);
      final controlPoint1 = Offset(start.dx + 50, start.dy);
      final controlPoint2 = Offset(end.dx - 50, end.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, end.dx, end.dy);
      
      // Draw glow
      canvas.drawPath(path, paint..strokeWidth = 4..color = QuestTheme.neonBlue.withOpacity(0.1));
      canvas.drawPath(path, paint..strokeWidth = 2..color = QuestTheme.neonBlue.withOpacity(0.5));

      // Arrowhead
      final arrowPaint = Paint()..color = QuestTheme.neonBlue.withOpacity(0.7)..style = PaintingStyle.fill;
      final arrowPath = Path();
      arrowPath.moveTo(end.dx, end.dy);
      arrowPath.lineTo(end.dx - 10, end.dy - 6);
      arrowPath.lineTo(end.dx - 10, end.dy + 6);
      arrowPath.close();
      canvas.drawPath(arrowPath, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant EdgePainter oldDelegate) => true;
}
