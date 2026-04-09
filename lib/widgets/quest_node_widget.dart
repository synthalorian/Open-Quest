import 'package:flutter/material.dart';
import '../models/quest_models.dart';

class QuestNodeWidget extends StatelessWidget {
  final QuestNode node;
  final bool isSelected;
  final bool isConnecting;
  final VoidCallback onTap;
  final Function(double dx, double dy) onDragEnd;
  final VoidCallback onConnect;
  final VoidCallback onDelete;

  const QuestNodeWidget({
    super.key, required this.node, required this.isSelected, required this.isConnecting,
    required this.onTap, required this.onDragEnd, required this.onConnect, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onPanEnd: (d) => onDragEnd(d.velocity.pixelsPerSecond.dx * 0.01, d.velocity.pixelsPerSecond.dy * 0.01),
      child: Container(
        width: 160, padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: node.type.color.withAlpha(isConnecting ? 100 : 40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.white : node.type.color, width: isSelected ? 2.5 : 1.5),
          boxShadow: isSelected ? [BoxShadow(color: node.type.color.withAlpha(60), blurRadius: 12)] : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: node.type.color, borderRadius: BorderRadius.circular(4)),
              child: Text(node.type.label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
            const Spacer(),
            if (isSelected) ...[
              GestureDetector(onTap: onConnect, child: const Icon(Icons.link, size: 16, color: Colors.white54)),
              const SizedBox(width: 4),
              GestureDetector(onTap: onDelete, child: const Icon(Icons.close, size: 16, color: Colors.white54)),
            ],
          ]),
          if (node.title.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(node.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
          if (node.content.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(node.content, style: const TextStyle(color: Colors.white54, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ]),
      ),
    );
  }
}
