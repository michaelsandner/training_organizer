import 'package:flutter/material.dart';

class ExerciseCarouselNameRow extends StatelessWidget {
  final String exerciseName;
  final bool collapsed;
  final VoidCallback onToggleCollapse;

  const ExerciseCarouselNameRow({
    super.key,
    required this.exerciseName,
    required this.collapsed,
    required this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Text(
              exerciseName,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        IconButton(
          icon: Icon(collapsed ? Icons.expand_more : Icons.expand_less),
          tooltip: collapsed ? 'Aufklappen' : 'Zuklappen',
          onPressed: onToggleCollapse,
        ),
      ],
    );
  }
}
