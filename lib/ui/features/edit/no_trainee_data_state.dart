import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/ui/features/import_export/file_cubit.dart';
import 'package:training_organizer/ui/features/import_export/file_state.dart';

class NoTraineeDataState extends StatelessWidget {
  const NoTraineeDataState({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileCubit, FileState>(
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage;
      },
      listener: (context, state) {
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 80,
                color: Theme.of(context).primaryColor.withAlpha(100),
              ),
              const SizedBox(height: 24),
              const Text(
                'Keine Mitgliedsdaten geladen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Importiere eine Datei um Mitgliedsdaten\nanzuzeigen und zu bearbeiten.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () async {
                  final fileCubit = context.read<FileCubit>();
                  final appCubit = context.read<TraineesCubit>();
                  final trainees = await fileCubit.loadFile();
                  if (trainees != null) {
                    appCubit.updateTraineeList(trainees);
                  }
                },
                icon: const Icon(Icons.file_upload),
                label: const Text('Datei importieren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
