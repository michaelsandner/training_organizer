import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_grouped_list_item.dart';

class ExerciseGroupedList extends StatelessWidget {
  final List<Exercise> exercises;
  final bool collapseAll;

  const ExerciseGroupedList({
    super.key,
    required this.exercises,
    required this.collapseAll,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = <ExerciseType, List<Exercise>>{};
    for (final exercise in exercises) {
      grouped.putIfAbsent(exercise.type, () => []).add(exercise);
    }

    final types = grouped.keys.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    final itemCount = types.fold<int>(
      0,
      (count, type) => count + 1 + grouped[type]!.length, // 1 header + exercises
    );

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ExerciseGroupedListItem(
          grouped: grouped,
          types: types,
          index: index,
          collapseAll: collapseAll,
        );
      },
    );
  }
}
