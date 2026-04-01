import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';

class ExerciseCarouselTypeRow extends StatelessWidget {
  final ExerciseType selectedType;
  final ValueChanged<ExerciseType> onTypeChanged;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback onRemove;

  const ExerciseCarouselTypeRow({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onRemove,
    this.onMoveUp,
    this.onMoveDown,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<ExerciseType>(
          value: selectedType,
          underline: const SizedBox(),
          items: ExerciseType.values
              .map((type) => DropdownMenuItem(
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
                  ))
              .toList(),
          onChanged: (type) {
            if (type != null) onTypeChanged(type);
          },
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: onMoveUp,
                  tooltip: 'Nach oben',
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: onMoveDown,
                  tooltip: 'Nach unten',
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemove,
                  tooltip: 'Entfernen',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
