import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
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
              child: _selectedTypeFilter == null
                  ? _buildGroupedList(filteredExercises)
                  : _buildFlatList(filteredExercises),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFlatList(List<Exercise> exercises) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return ExerciseListItem(
          exercise: exercises[index],
          collapseAll: _collapseAll,
        );
      },
    );
  }

  Widget _buildGroupedList(List<Exercise> exercises) {
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
        return _buildTypeHeader(type);
      }
      if (index <= offset + exercises.length) {
        return ExerciseListItem(
          exercise: exercises[index - offset - 1],
          collapseAll: _collapseAll,
        );
      }
      offset += 1 + exercises.length;
    }
    return const SizedBox.shrink();
  }

  Widget _buildTypeHeader(ExerciseType type) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
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
          Text(
            type.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: type.color,
            ),
          ),
        ],
      ),
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
