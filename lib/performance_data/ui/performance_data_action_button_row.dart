import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/performance_data/ui/performance_data_cubit.dart';

/// Row of floating action buttons for import and export.
class PerformanceDataActionButtonRow extends StatelessWidget {
  const PerformanceDataActionButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: 'import',
          onPressed: () => context.read<PerformanceDataCubit>().importData(),
          icon: const Icon(Icons.file_upload),
          label: const Text('Importieren'),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.extended(
          heroTag: 'export',
          onPressed: () => context.read<PerformanceDataCubit>().exportData(),
          icon: const Icon(Icons.file_download),
          label: const Text('Exportieren'),
        ),
      ],
    );
  }
}
