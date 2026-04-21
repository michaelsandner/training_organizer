import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_description_section.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_link_image_row.dart';

class ExerciseCarouselItem extends StatelessWidget {
  final Exercise exercise;
  final int distance;
  final Color color;
  final ValueChanged<int> onDistanceChanged;

  const ExerciseCarouselItem({
    super.key,
    required this.exercise,
    required this.distance,
    required this.color,
    required this.onDistanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '#${exercise.id}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      exercise.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      initialValue: distance.toString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        final d = int.tryParse(value);
                        if (d != null) {
                          onDistanceChanged(d);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    exercise.unit,
                    style: const TextStyle(fontSize: 14, height: 1.1),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: ExerciseLinkImageRow(exercise: exercise),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ExerciseDescriptionSection(exercise: exercise),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
