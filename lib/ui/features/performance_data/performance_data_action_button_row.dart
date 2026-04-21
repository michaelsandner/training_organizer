import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_cubit.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_state.dart';

/// Row of floating action buttons for import, export and iCal-Import.
class PerformanceDataActionButtonRow extends StatelessWidget {
  const PerformanceDataActionButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerformanceDataCubit, PerformanceDataState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              heroTag: 'import',
              onPressed: () =>
                  context.read<PerformanceDataCubit>().importData(),
              icon: const Icon(Icons.file_upload),
              label: const Text('Importieren'),
            ),
            const SizedBox(width: 12),
            FloatingActionButton.extended(
              heroTag: 'export',
              onPressed: () =>
                  context.read<PerformanceDataCubit>().exportData(),
              icon: const Icon(Icons.file_download),
              label: const Text('Exportieren'),
            ),
            const SizedBox(width: 12),
            _YearPickerButton(selectedYear: state.selectedYear),
            const SizedBox(width: 12),
            FloatingActionButton.extended(
              heroTag: 'ical_import',
              onPressed: () =>
                  context.read<PerformanceDataCubit>().importIcal(),
              icon: const Icon(Icons.calendar_month),
              label: const Text('iCal importieren'),
            ),
            const SizedBox(width: 12),
            FloatingActionButton.extended(
              heroTag: 'badge_import',
              onPressed: () => context
                  .read<PerformanceDataCubit>()
                  .importBadges(context.read<TraineesCubit>().state.trainees),
              icon: const Icon(Icons.military_tech),
              label: const Text('Abzeichen importieren'),
            ),
          ],
        );
      },
    );
  }
}

class _YearPickerButton extends StatelessWidget {
  final int selectedYear;

  const _YearPickerButton({required this.selectedYear});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'year_picker',
      onPressed: () => _showYearPicker(context),
      icon: const Icon(Icons.date_range),
      label: Text('$selectedYear'),
    );
  }

  void _showYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Jahr auswählen'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              selectedDate: DateTime(selectedYear),
              currentDate: DateTime.now(),
              onChanged: (DateTime dateTime) {
                context
                    .read<PerformanceDataCubit>()
                    .setSelectedYear(dateTime.year);
                Navigator.of(dialogContext).pop();
              },
            ),
          ),
        );
      },
    );
  }
}
