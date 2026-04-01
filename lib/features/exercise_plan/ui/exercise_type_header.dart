import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';

class ExerciseTypeHeader extends StatelessWidget {
  final ExerciseType type;

  const ExerciseTypeHeader({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: type.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            type.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: type.color,
            ),
          ),
        ],
      ),
    );
  }
}
