import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_description_section.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_image_placeholder.dart';

class ExerciseImageDetailPage extends StatelessWidget {
  final Exercise exercise;

  const ExerciseImageDetailPage({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    final color = exercise.type.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      backgroundColor: color.withAlpha(30),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Hero(
                tag: 'exercise-image-${exercise.id}',
                child: exercise.imageName != null
                    ? Image.asset(
                        'assets/images/${exercise.imageName}',
                        fit: BoxFit.contain,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return ExerciseImagePlaceholder(
                            color: color,
                            size: 120,
                            iconSize: 64,
                            borderRadius: 16,
                          );
                        },
                      )
                    : ExerciseImagePlaceholder(
                        color: color,
                        size: 120,
                        iconSize: 64,
                        borderRadius: 16,
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
