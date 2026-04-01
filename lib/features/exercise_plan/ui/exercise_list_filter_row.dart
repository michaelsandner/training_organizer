import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';

class ExerciseListFilterRow extends StatelessWidget {
  final ExerciseType? selectedTypeFilter;
  final bool collapseAll;
  final ValueChanged<ExerciseType?> onTypeChanged;
  final VoidCallback onCollapseAllToggled;

  const ExerciseListFilterRow({
    super.key,
    required this.selectedTypeFilter,
    required this.collapseAll,
    required this.onTypeChanged,
    required this.onCollapseAllToggled,
  });

  @override
  Widget build(BuildContext context) {
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
              value: selectedTypeFilter,
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
              onChanged: (type) => onTypeChanged(type),
            ),
          ),
          IconButton(
            icon: Icon(collapseAll ? Icons.unfold_more : Icons.unfold_less),
            tooltip: collapseAll ? 'Alle aufklappen' : 'Alle zuklappen',
            onPressed: onCollapseAllToggled,
          ),
        ],
      ),
    );
  }
}
