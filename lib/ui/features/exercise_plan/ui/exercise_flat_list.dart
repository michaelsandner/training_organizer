import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_list_item.dart';

class ExerciseFlatList extends StatelessWidget {
  final List<Exercise> exercises;
  final bool collapseAll;

  const ExerciseFlatList({
    super.key,
    required this.exercises,
    required this.collapseAll,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return ExerciseListItem(
          exercise: exercises[index],
          collapseAll: collapseAll,
        );
      },
    );
  }
}
