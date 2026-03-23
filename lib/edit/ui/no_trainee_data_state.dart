import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/overview/trainees_cubit.dart';
import 'package:training_organizer/import_export/ui/file_cubit.dart';

class NoTraineeDataState extends StatelessWidget {
  const NoTraineeDataState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                appCubit.updateTraineeList(trainees);
              },
              icon: const Icon(Icons.file_upload),
              label: const Text('Datei importieren'),
            ),
          ],
        ),
      ),
    );
  }
}
