import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/file_cubit.dart';
import 'package:training_organizer/cubit/file_state.dart';

class ImportView extends StatelessWidget {
  const ImportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileCubit, FileState>(
      listenWhen: (previous, current) {
        return previous.exportState == ExportState.none;
      },
      listener: (context, state) {
        if (state.exportState == ExportState.exportSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export successful')),
          );
        }
        if (state.exportState == ExportState.exportFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Something got wrong with the export')),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ImportButton(),
          if (!kIsWeb) _ExportButton(),
        ],
      ),
    );
  }
}

class _ImportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    final fileCubit = context.read<FileCubit>();
    return ElevatedButton(
      onPressed: () async {
        final trainees = await fileCubit.loadFile();
        cubit.updateTraineeList(trainees);
      },
      child: const Text('Import'),
    );
  }
}

class _ExportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    final fileCubit = context.read<FileCubit>();
    return ElevatedButton(
      onPressed: () => fileCubit.saveFile(cubit.state.trainees),
      child: const Text('Export'),
    );
  }
}
