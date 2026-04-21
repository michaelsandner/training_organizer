import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/overview/button_row.dart';
import 'package:training_organizer/ui/features/import_export/file_cubit.dart';
import 'package:training_organizer/ui/features/import_export/file_state.dart';

class AttendanceButtonRow extends StatelessWidget {
  const AttendanceButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileCubit, FileState>(
      listenWhen: (previous, current) {
        return previous.exportState != current.exportState ||
            previous.errorMessage != current.errorMessage;
      },
      listener: (context, state) {
        if (state.exportState == ExportState.exportSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export successful')),
          );
        }
        if (state.exportState == ExportState.exportFailed &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade100,
              leading: const Icon(Icons.error_outline, color: Colors.red),
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          );
        }
        if (state.errorMessage != null &&
            state.exportState == ExportState.none) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade100,
              leading: const Icon(Icons.error_outline, color: Colors.red),
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          );
        }
      },
      child: Align(
        alignment: Alignment.bottomRight,
        child: _AttendanceButtonContainer(),
      ),
    );
  }
}

class _AttendanceButtonContainer extends StatelessWidget {
  bool _isMobileLayout(BuildContext context) {
    final data = MediaQueryData.fromView(View.of(context));
    return data.size.shortestSide < 700;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobileLayout(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ImportButton(isMobile: isMobile),
        const SizedBox(width: 5),
        ExportButton(isMobile: isMobile),
        const SizedBox(width: 5),
      ],
    );
  }
}
