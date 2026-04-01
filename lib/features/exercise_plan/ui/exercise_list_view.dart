import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_list_item.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_cubit.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_state.dart';

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
            _buildFilterRow(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: filteredExercises.length,
                itemBuilder: (context, index) {
                  return ExerciseListItem(
                    exercise: filteredExercises[index],
                    collapseAll: _collapseAll,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Text(
            'Typ: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: DropdownButton<ExerciseType?>(
              value: _selectedTypeFilter,
              isExpanded: true,
              underline: const SizedBox(),
              items: [
                const DropdownMenuItem<ExerciseType?>(
                  value: null,
                  child: Text('Alle'),
                ),
                ...ExerciseType.values.map(
                  (type) => DropdownMenuItem<ExerciseType?>(
                    value: type,
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
                        Text(type.displayName),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (type) {
                setState(() {
                  _selectedTypeFilter = type;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(_collapseAll ? Icons.unfold_more : Icons.unfold_less),
            tooltip: _collapseAll ? 'Alle aufklappen' : 'Alle zuklappen',
            onPressed: () {
              setState(() {
                _collapseAll = !_collapseAll;
              });
            },
          ),
        ],
      ),
    );
  }
}
