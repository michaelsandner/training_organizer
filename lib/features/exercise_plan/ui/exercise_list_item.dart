import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';

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
  bool _collapsed = true;

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
                  Text(exercise.description),
                  if (exercise.imageName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: TextButton.icon(
                        onPressed: () => _showImageDialog(context),
                        icon: const Icon(Icons.image),
                        label: const Text('Bild anzeigen'),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.exercise.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/${widget.exercise.imageName}',
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Bild nicht gefunden');
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Schließen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
