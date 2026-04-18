import 'package:flutter/material.dart';

class ExercisePlanDeleteDialog extends StatelessWidget {
  const ExercisePlanDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Trainingsplan löschen'),
      content: const Text('Willst du den Trainingsplan löschen?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Löschen'),
        ),
      ],
    );
  }
}
