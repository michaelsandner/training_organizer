import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/data/file_handler.dart';
import 'package:training_organizer/ui/features/import_export/file_state.dart';
import 'package:training_organizer/model/trainee.dart';

class FileCubit extends Cubit<FileState> {
  final FileExporter _fileExporter;
  FileCubit(this._fileExporter) : super(FileState.initial());

  void setShowLoadingIndicator(bool shouldShow) {
    emit(state.copyWith(showLoadingSpinner: shouldShow));
  }

  Future<List<Trainee>?> loadFile() async {
    try {
      setShowLoadingIndicator(true);
      emit(state.copyWith(clearErrorMessage: true));
      final trainees = await _fileExporter.importTrainees();
      setShowLoadingIndicator(false);
      if (trainees.isEmpty) return null;
      return trainees;
    } catch (e) {
      setShowLoadingIndicator(false);
      emit(state.copyWith(
          errorMessage: 'Import fehlgeschlagen: ${e.toString()}'));
      return null;
    }
  }

  Future<void> saveFile(List<Trainee> trainees) async {
    try {
      await _fileExporter.exportTrainees(trainees);
      emit(state.copyWith(exportState: ExportState.exportSuccessful));
    } catch (e) {
      emit(state.copyWith(
        exportState: ExportState.exportFailed,
        errorMessage: 'Export failed: ${e.toString()}',
      ));
    } finally {
      emit(state.copyWith(exportState: ExportState.none));
    }
  }

  Future<void> saveRescueCertificationAttendeesAsCsv(
      List<Trainee> trainees, String qualificationSuffix) async {
    try {
      await _fileExporter.exportCertificationAttendeesAsCsv(
          trainees, qualificationSuffix);
      emit(state.copyWith(exportState: ExportState.exportSuccessful));
    } catch (e) {
      emit(state.copyWith(
        exportState: ExportState.exportFailed,
        errorMessage: 'Export fehlgeschlagen: ${e.toString()}',
      ));
    } finally {
      emit(state.copyWith(exportState: ExportState.none));
    }
  }
}
