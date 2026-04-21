import 'package:flutter/material.dart';

class ExercisePlanAddButton extends StatelessWidget {
  final VoidCallback onAddEntry;

  const ExercisePlanAddButton({
    super.key,
    required this.onAddEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton.icon(
        onPressed: onAddEntry,
        icon: const Icon(Icons.add),
        label: const Text('Übung hinzufügen'),
      ),
    );
  }
}
