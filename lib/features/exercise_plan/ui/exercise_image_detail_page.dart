import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_description_section.dart';

class ExerciseImageDetailPage extends StatelessWidget {
  final Exercise exercise;

  const ExerciseImageDetailPage({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Hero(
                tag: 'exercise-image-${exercise.id}',
                child: Image.asset(
                  'assets/images/${exercise.imageName}',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Bild nicht gefunden'));
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ExerciseDescriptionSection(exercise: exercise),
            ),
          ),
        ],
      ),
    );
  }
}
