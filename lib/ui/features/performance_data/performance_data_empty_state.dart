import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_cubit.dart';

/// Empty state widget shown when no performance data is loaded.
class PerformanceDataEmptyState extends StatelessWidget {
  const PerformanceDataEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 80,
              color: Theme.of(context).primaryColor.withAlpha(100),
            ),
            const SizedBox(height: 24),
            const Text(
              'Keine Leistungsdaten geladen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Importiere eine JSON-Datei um Leistungsdaten\nanzuzeigen und zu bearbeiten.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () =>
                  context.read<PerformanceDataCubit>().importData(),
              icon: const Icon(Icons.file_upload),
              label: const Text('JSON-Datei importieren'),
            ),
          ],
        ),
      ),
    );
  }
}
