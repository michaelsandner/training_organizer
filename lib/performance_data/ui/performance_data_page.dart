import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/performance_data/ui/performance_data_action_button_row.dart';
import 'package:training_organizer/performance_data/ui/performance_data_body.dart';
import 'package:training_organizer/performance_data/ui/performance_data_cubit.dart';
import 'package:training_organizer/performance_data/ui/performance_data_state.dart';

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
