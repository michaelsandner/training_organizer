import 'package:flutter/material.dart';

class ExercisePlanExportDialog extends StatefulWidget {
  const ExercisePlanExportDialog({super.key});

  @override
  State<ExercisePlanExportDialog> createState() =>
      _ExercisePlanExportDialogState();
}

class _ExercisePlanExportDialogState extends State<ExercisePlanExportDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Trainingspläne exportieren'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Dateiname',
          border: OutlineInputBorder(),
          hintText: 'trainingsplaene',
        ),
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: _controller.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text('Exportieren'),
        ),
      ],
    );
  }
}
