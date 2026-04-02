import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_row.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_add_button.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_cubit.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_state.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_string_row.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_unit_summary_row.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_view_toggle_row.dart';

class ExercisePlanBody extends StatelessWidget {
  final ExercisePlanState state;
  final bool showListView;
  final bool collapseAll;
  final ValueChanged<bool> onViewChanged;
  final VoidCallback onToggleCollapseAll;

  const ExercisePlanBody({
    super.key,
    required this.state,
    required this.showListView,
    required this.collapseAll,
    required this.onViewChanged,
    required this.onToggleCollapseAll,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExercisePlanCubit>();
    return Column(
      children: [
        ExerciseViewToggleRow(
          showListView: showListView,
          onViewChanged: onViewChanged,
        ),
        ExercisePlanStringRow(
          planString: state.planString,
          collapseAll: collapseAll,
          onToggleCollapseAll: onToggleCollapseAll,
        ),
        ExercisePlanUnitSummaryRow(unitSummary: state.unitSummary),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.entries.length,
            itemBuilder: (context, index) {
              final entry = state.entries[index];
              final isFirst = index == 0;
              final isLast = index == state.entries.length - 1;
              return ExerciseCarouselRow(
                index: index,
                selectedType: entry.type,
                selectedExerciseId: entry.selectedExerciseId,
                distance: entry.distance,
                allExercises: state.exercises,
                onTypeChanged: (type) => cubit.updateEntryType(index, type),
                onExerciseChanged: (id) =>
                    cubit.updateEntryExercise(index, id),
                onDistanceChanged: (distance) =>
                    cubit.updateEntryDistance(index, distance),
                onRemove: () => cubit.removeEntry(index),
                onMoveUp: isFirst ? null : () => cubit.moveEntryUp(index),
                onMoveDown: isLast ? null : () => cubit.moveEntryDown(index),
                collapseAll: collapseAll,
              );
            },
          ),
        ),
        ExercisePlanAddButton(onAddEntry: cubit.addEntry),
      ],
    );
  }
}
