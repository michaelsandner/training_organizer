import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_list_item.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_type_header.dart';

class ExerciseGroupedListItem extends StatelessWidget {
  final Map<ExerciseType, List<Exercise>> grouped;
  final List<ExerciseType> types;
  final int index;
  final bool collapseAll;

  const ExerciseGroupedListItem({
    super.key,
    required this.grouped,
    required this.types,
    required this.index,
    required this.collapseAll,
  });

  @override
  Widget build(BuildContext context) {
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
