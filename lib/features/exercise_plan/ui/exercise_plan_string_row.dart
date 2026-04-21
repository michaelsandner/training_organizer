import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_cubit.dart';

class ExercisePlanStringRow extends StatelessWidget {
  final String planString;
  final bool collapseAll;
  final VoidCallback onToggleCollapseAll;

  const ExercisePlanStringRow({
    super.key,
    required this.planString,
    required this.collapseAll,
    required this.onToggleCollapseAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Text(
            'Trainingsplan ID: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: TextFormField(
              key: ValueKey(planString),
              initialValue: planString,
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
            icon: Icon(collapseAll ? Icons.unfold_less : Icons.unfold_more),
            tooltip: collapseAll ? 'Alle aufklappen' : 'Alle zuklappen',
            onPressed: onToggleCollapseAll,
          ),
        ],
      ),
    );
  }
}
