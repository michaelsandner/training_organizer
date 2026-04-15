import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_description_section.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_link_image_row.dart';

class ExerciseListItem extends StatefulWidget {
  final Exercise exercise;
  final bool collapseAll;

  const ExerciseListItem({
    super.key,
    required this.exercise,
    this.collapseAll = false,
  });

  @override
  State<ExerciseListItem> createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends State<ExerciseListItem> {
  late bool _collapsed;

  @override
  void initState() {
    super.initState();
    _collapsed = widget.collapseAll;
  }

  @override
  void didUpdateWidget(covariant ExerciseListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collapseAll != widget.collapseAll) {
      setState(() {
        _collapsed = widget.collapseAll;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final color = exercise.type.color;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _collapsed = !_collapsed),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withAlpha(50),
                borderRadius: _collapsed
                    ? BorderRadius.circular(10)
                    : const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
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
                  Icon(
                    _collapsed ? Icons.expand_more : Icons.expand_less,
                    color: color,
                  ),
                ],
              ),
            ),
          ),
          if (!_collapsed)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '#${exercise.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        exercise.type.displayName,
                        style: TextStyle(color: color),
                      ),
                      const Spacer(),
                      Text(
                        exercise.unit,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (exercise.imageName != null ||
                          exercise.link != null)
                        Expanded(
                          flex: 1,
                          child:
                              ExerciseLinkImageRow(exercise: exercise),
                        ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: (exercise.imageName != null ||
                                    exercise.link != null)
                                ? 8
                                : 0,
                          ),
                          child: ExerciseDescriptionSection(
                              exercise: exercise),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
