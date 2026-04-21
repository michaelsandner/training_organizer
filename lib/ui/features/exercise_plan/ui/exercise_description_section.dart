import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';

class ExerciseDescriptionSection extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDescriptionSection({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    final hasMaterial =
        exercise.material != null && exercise.material!.isNotEmpty;
    final hasVarianten =
        exercise.varianten != null && exercise.varianten!.isNotEmpty;
    final hasExtraFields = hasMaterial || hasVarianten;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasExtraFields)
          const Text(
            'Ablauf',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        Text(exercise.description),
        if (hasMaterial) ...[
          const SizedBox(height: 8),
          const Text(
            'Material',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(exercise.material!),
        ],
        if (hasVarianten) ...[
          const SizedBox(height: 8),
          const Text(
            'Varianten',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(exercise.varianten!),
        ],
      ],
    );
  }
}
