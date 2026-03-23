import 'package:flutter/material.dart';
import 'package:training_organizer/domain/badge_import_result.dart';

/// Confirmation dialog for the badge import.
/// Shows the badges that will be added to performance data categories.
class BadgeImportDialog extends StatelessWidget {
  final BadgeImportResult importResult;
  final VoidCallback onConfirm;
  final VoidCallback onAbort;

  const BadgeImportDialog({
    super.key,
    required this.importResult,
    required this.onConfirm,
    required this.onAbort,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Abzeichen importieren'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (importResult.entries.isEmpty)
              const Text('Keine Abzeichen für das ausgewählte Jahr gefunden.')
            else ...[
              const Text(
                'Folgende Abzeichen werden hinzugefügt:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              for (final entry in importResult.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.beschreibung.isNotEmpty
                              ? '${entry.targetCategoryName} (${entry.beschreibung})'
                              : entry.targetCategoryName,
                        ),
                      ),
                      Text(
                        '${entry.count}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onAbort,
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: onConfirm,
          child: const Text('Übernehmen'),
        ),
      ],
    );
  }
}
