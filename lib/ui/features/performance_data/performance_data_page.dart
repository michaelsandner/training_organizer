import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/performance_data/badge_import_dialog.dart';
import 'package:training_organizer/ui/features/performance_data/ical_import_dialog.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_action_button_row.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_body.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_cubit.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_state.dart';

/// Page that displays imported performance data in a tree structure.
/// Uses the global [PerformanceDataCubit] so data survives navigation.
class PerformanceDataPage extends StatelessWidget {
  const PerformanceDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PerformanceDataCubit, PerformanceDataState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state.exportState == PerformanceDataExportState.exportSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Export erfolgreich'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state.icalImportResult != null && state.performanceData != null) {
          final data = state.performanceData!;
          final result = state.icalImportResult!;

          // Aggregate apply entries by target category name
          final aggregated = <String, int>{};
          for (final entry in result.applyEntries) {
            aggregated[entry.targetCategoryName] =
                (aggregated[entry.targetCategoryName] ?? 0) + entry.value;
          }
          final changePreviews = aggregated.entries.map((entry) {
            final current = data.findCountByName(entry.key) ?? 0;
            return IcalChangePreview(
              categoryName: entry.key,
              parsedDelta: entry.value,
              currentValue: current,
            );
          }).toList();

          showDialog(
            context: context,
            builder: (_) => IcalImportDialog(
              importResult: result,
              changePreviews: changePreviews,
              onConfirm: () {
                context.read<PerformanceDataCubit>().applyIcalImport();
                Navigator.of(context).pop();
              },
              onAbort: () {
                context.read<PerformanceDataCubit>().dismissIcalImport();
                Navigator.of(context).pop();
              },
            ),
          );
        }
        if (state.badgeImportResult != null) {
          showDialog(
            context: context,
            builder: (_) => BadgeImportDialog(
              importResult: state.badgeImportResult!,
              onConfirm: () {
                context.read<PerformanceDataCubit>().applyBadgeImport();
                Navigator.of(context).pop();
              },
              onAbort: () {
                context.read<PerformanceDataCubit>().dismissBadgeImport();
                Navigator.of(context).pop();
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Leistungsdaten'),
          ),
          floatingActionButton: state.performanceData != null
              ? const PerformanceDataActionButtonRow()
              : null,
          body: PerformanceDataBody(state: state),
        );
      },
    );
  }
}
