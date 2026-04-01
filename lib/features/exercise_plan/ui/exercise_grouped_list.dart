import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_list_item.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_type_header.dart';

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

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _countGroupedItems(grouped, types),
      itemBuilder: (context, index) {
        return _buildGroupedItem(grouped, types, index);
      },
    );
  }

  int _countGroupedItems(
    Map<ExerciseType, List<Exercise>> grouped,
    List<ExerciseType> types,
  ) {
    int count = 0;
    for (final type in types) {
      count += 1 + grouped[type]!.length; // 1 header + exercises
    }
    return count;
  }

  Widget _buildGroupedItem(
    Map<ExerciseType, List<Exercise>> grouped,
    List<ExerciseType> types,
    int index,
  ) {
    int offset = 0;
    for (final type in types) {
      final exercises = grouped[type]!;
      if (index == offset) {
        return ExerciseTypeHeader(type: type);
      }
      if (index <= offset + exercises.length) {
        return ExerciseListItem(
          exercise: exercises[index - offset - 1],
          collapseAll: collapseAll,
        );
      }
      offset += 1 + exercises.length; // 1 header + exercises
    }
    return const SizedBox.shrink();
  }
}
