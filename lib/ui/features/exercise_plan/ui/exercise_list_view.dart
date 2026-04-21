import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_flat_list.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_grouped_list.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_list_filter_row.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_plan_cubit.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_plan_state.dart';

class ExerciseListView extends StatefulWidget {
  const ExerciseListView({super.key});

  @override
  State<ExerciseListView> createState() => _ExerciseListViewState();
}

class _ExerciseListViewState extends State<ExerciseListView> {
  ExerciseType? _selectedTypeFilter;
  bool _collapseAll = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisePlanCubit, ExercisePlanState>(
      builder: (context, state) {
        if (state.exercises.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredExercises = _selectedTypeFilter == null
            ? state.exercises
            : state.exercises
                .where((e) => e.type == _selectedTypeFilter)
                .toList();

        return Column(
          children: [
            ExerciseListFilterRow(
              selectedTypeFilter: _selectedTypeFilter,
              collapseAll: _collapseAll,
              onTypeChanged: (type) {
                setState(() {
                  _selectedTypeFilter = type;
                });
              },
              onCollapseAllToggled: () {
                setState(() {
                  _collapseAll = !_collapseAll;
                });
              },
            ),
            Expanded(
              child: _selectedTypeFilter == null
                  ? ExerciseGroupedList(
                      exercises: filteredExercises,
                      collapseAll: _collapseAll,
                    )
                  : ExerciseFlatList(
                      exercises: filteredExercises,
                      collapseAll: _collapseAll,
                    ),
            ),
          ],
        );
      },
    );
  }
}
