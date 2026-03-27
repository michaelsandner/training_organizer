import 'package:flutter/material.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise.dart';

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
    return Card(
      color: color.withAlpha(30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 2),
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
                    height: 28,
                    child: TextFormField(
                      initialValue: distance.toString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, height: 1.1),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
                  Text(exercise.unit),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(exercise.description),
              ),
              if (exercise.imageName != null)
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 4),
                  child: TextButton.icon(
                    onPressed: () => _showImageDialog(context),
                    icon: const Icon(Icons.image),
                    label: const Text('Bild anzeigen'),
                  ),
                ),
            ],
          ),
        ),
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
                exercise.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/${exercise.imageName}',
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
