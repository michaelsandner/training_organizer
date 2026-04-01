import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_row.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_cubit.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_state.dart';

class ExercisePlanPage extends StatefulWidget {
  const ExercisePlanPage({super.key});

  @override
  State<ExercisePlanPage> createState() => _ExercisePlanPageState();
}

class _ExercisePlanPageState extends State<ExercisePlanPage> {
  bool _collapseAll = false;

  void _toggleCollapseAll() {
    setState(() {
      _collapseAll = !_collapseAll;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExercisePlanCubit, ExercisePlanState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.exercises.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildBody(context, state);
      },
    );
  }

  Widget _buildBody(BuildContext context, ExercisePlanState state) {
    final cubit = context.read<ExercisePlanCubit>();

    return Column(
      children: [
        _buildPlanStringRow(context, state),
        _buildUnitSummaryRow(state),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.entries.length,
            itemBuilder: (context, index) {
              final entry = state.entries[index];
              return ExerciseCarouselRow(
                index: index,
                selectedType: entry.type,
                selectedExerciseId: entry.selectedExerciseId,
                distance: entry.distance,
                allExercises: state.exercises,
                onTypeChanged: (type) => cubit.updateEntryType(index, type),
                onExerciseChanged: (id) => cubit.updateEntryExercise(index, id),
                onDistanceChanged: (distance) =>
                    cubit.updateEntryDistance(index, distance),
                onRemove: () => cubit.removeEntry(index),
                collapseAll: _collapseAll,
              );
            },
          ),
        ),
        _buildAddButton(cubit),
      ],
    );
  }

  Widget _buildUnitSummaryRow(ExercisePlanState state) {
    final summary = state.unitSummary;
    if (summary.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        spacing: 16,
        children: summary.entries
            .map(
              (e) => Text(
                '${e.value} ${e.key}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildPlanStringRow(BuildContext context, ExercisePlanState state) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Text(
            'Trainingsplan: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: TextFormField(
              key: ValueKey(state.planString),
              initialValue: state.planString,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                hintText: '1-2-3',
              ),
              onFieldSubmitted: (value) {
                context.read<ExercisePlanCubit>().applyPlanString(value);
              },
            ),
          ),
          IconButton(
            icon: Icon(_collapseAll ? Icons.unfold_less : Icons.unfold_more),
            tooltip: _collapseAll ? 'Alle aufklappen' : 'Alle zuklappen',
            onPressed: _toggleCollapseAll,
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(ExercisePlanCubit cubit) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton.icon(
        onPressed: cubit.addEntry,
        icon: const Icon(Icons.add),
        label: const Text('Übung hinzufügen'),
      ),
    );
  }
}
