import 'package:flutter/material.dart';

class ExercisePlanImportWarningDialog extends StatelessWidget {
  const ExercisePlanImportWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Trainingspläne importieren'),
      content: const Text(
        'Beim Import werden alle gespeicherten Trainingspläne gelöscht. Fortfahren?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Importieren'),
        ),
      ],
    );
  }
}
