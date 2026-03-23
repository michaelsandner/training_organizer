import 'package:flutter/material.dart';
import 'package:training_organizer/domain/ical_parser/ical_import_result.dart';

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
              _buildRow(row.label, '${row.value}'),
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
              _buildRow('Aktueller Wert:', '${preview.currentValue}'),
              _buildRow(
                'Neuer Wert:',
                '${preview.newValue}',
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

  Widget _buildRow(String label, String value, {bool highlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: highlighted ? FontWeight.bold : FontWeight.normal,
              color: highlighted ? Colors.blue : null,
            ),
          ),
        ],
      ),
    );
  }
}
