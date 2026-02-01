import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/file_cubit.dart';
import 'package:training_organizer/cubit/file_state.dart';
import 'package:training_organizer/view/edit_view/add_trainee.dart';

class ButtonRow extends StatelessWidget {
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
      child: Align(
        alignment: Alignment.bottomRight,
        child: DefaultButtonContainer(),
      ),
    );
  }
}

class DefaultButtonContainer extends StatelessWidget {
  bool isMobileLayout(BuildContext context) {
    final data = MediaQueryData.fromView(View.of(context));
    return data.size.shortestSide < 700;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = isMobileLayout(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ImportButton(isMobile: isMobile),
        const SizedBox(width: 5),
        if (!kIsWeb) ExportButton(isMobile: isMobile),
        if (!kIsWeb) const SizedBox(width: 5),
        AddButton(isMobile: isMobile),
        const SizedBox(width: 5),
      ],
    );
  }
}

class ImportButton extends StatelessWidget {
  final bool isMobile;

  const ImportButton({required this.isMobile});

  String get title => isMobile ? 'Import' : 'Importieren';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    final fileCubit = context.read<FileCubit>();
    return FloatingActionButton.extended(
      heroTag: 'importButton',
      onPressed: () async {
        final trainees = await fileCubit.loadFile();
        cubit.updateTraineeList(trainees);
      },
      icon: const Icon(Icons.data_object),
      label: Text(title),
    );
  }
}

class ExportButton extends StatelessWidget {
  final bool isMobile;
  const ExportButton({required this.isMobile});

  String get title => isMobile ? 'Export' : 'Exportieren';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    final fileCubit = context.read<FileCubit>();
    return FloatingActionButton.extended(
      heroTag: 'exportButton',
      onPressed: () => fileCubit.saveFile(cubit.state.trainees),
      icon: const Icon(Icons.data_object),
      label: Text(title),
    );
  }
}

class AddButton extends StatelessWidget {
  final bool isMobile;
  const AddButton({required this.isMobile});

  String get title => isMobile ? '' : 'Hinzufügen';

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'addButton',
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AddTrainee())),
      icon: const Icon(Icons.add),
      label: Text(title),
    );
  }
}
