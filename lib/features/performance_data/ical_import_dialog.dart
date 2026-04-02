import 'package:flutter/material.dart';
import 'package:training_organizer/domain/ical_parser/ical_import_result.dart';
import 'package:training_organizer/features/performance_data/ical_import_row.dart';

/// Preview of changes to a single performance data category.
class IcalChangePreview {
  final String categoryName;
  final int parsedDelta;
  final int currentValue;

  const IcalChangePreview({
    required this.categoryName,
    required this.parsedDelta,
    required this.currentValue,
  });

  int get newValue => currentValue + parsedDelta;
}

/// Confirmation dialog for the iCal import.
/// Shows the parsed values and the sum with existing values.
class IcalImportDialog extends StatelessWidget {
  final IcalImportResult importResult;
  final List<IcalChangePreview> changePreviews;
  final VoidCallback onConfirm;
  final VoidCallback onAbort;

  const IcalImportDialog({
    super.key,
    required this.importResult,
    required this.changePreviews,
    required this.onConfirm,
    required this.onAbort,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('iCal-Import Ergebnis'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Geparste Positionen:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (final row in importResult.displayRows)
              IcalImportRow(label: row.label, value: '${row.value}'),
            const Divider(height: 24),
            const Text(
              'Änderungen an Leistungsdaten:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (final preview in changePreviews) ...[
              Text(
                preview.categoryName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              IcalImportRow(
                label: 'Aktueller Wert:',
                value: '${preview.currentValue}',
              ),
              IcalImportRow(
                label: 'Neuer Wert:',
                value: '${preview.newValue}',
                highlighted: true,
              ),
              const SizedBox(height: 8),
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
