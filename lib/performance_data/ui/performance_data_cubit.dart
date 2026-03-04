import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/data/performance_data_file_handler.dart';
import 'package:training_organizer/performance_data/domain/category_position.dart';
import 'package:training_organizer/performance_data/ui/performance_data_state.dart';

class PerformanceDataCubit extends Cubit<PerformanceDataState> {
  final PerformanceDataFileHandler _fileHandler;

  PerformanceDataCubit(this._fileHandler)
      : super(PerformanceDataState.initial());

  Future<void> importData() async {
    try {
      emit(state.copyWith(showLoadingSpinner: true, errorMessage: null));
      final data = await _fileHandler.importPerformanceData();
      if (data != null) {
        emit(state.copyWith(
          performanceData: data,
          showLoadingSpinner: false,
        ));
      } else {
        emit(state.copyWith(showLoadingSpinner: false));
      }
    } catch (e) {
      emit(state.copyWith(
        showLoadingSpinner: false,
        errorMessage: 'Import fehlgeschlagen: ${e.toString()}',
      ));
    }
  }

  Future<void> exportData() async {
    final data = state.performanceData;
    if (data == null) return;

    try {
      await _fileHandler.exportPerformanceData(data);
      emit(state.copyWith(
        exportState: PerformanceDataExportState.exportSuccessful,
      ));
    } catch (e) {
      emit(state.copyWith(
        exportState: PerformanceDataExportState.exportFailed,
        errorMessage: 'Export fehlgeschlagen: ${e.toString()}',
      ));
    } finally {
      emit(state.copyWith(
        exportState: PerformanceDataExportState.none,
      ));
    }
  }

  void updateCount(List<int> path, int newCount) {
    final data = state.performanceData;
    if (data == null) return;

    final updatedData = data.updateCount(path, newCount);
    emit(state.copyWith(performanceData: updatedData));
  }

  /// Updates a single position inside a leaf category.
  void updatePosition(List<int> categoryPath, int positionIndex,
      CategoryPosition updatedPosition) {
    final data = state.performanceData;
    if (data == null) return;

    final updatedData =
        data.updatePosition(categoryPath, positionIndex, updatedPosition);
    emit(state.copyWith(performanceData: updatedData));
  }

  /// Adds a new empty position to a leaf category.
  void addPosition(List<int> categoryPath) {
    final data = state.performanceData;
    if (data == null) return;

    final updatedData = data.addPosition(categoryPath);
    emit(state.copyWith(performanceData: updatedData));
  }

  /// Removes a position from a leaf category.
  void removePosition(List<int> categoryPath, int positionIndex) {
    final data = state.performanceData;
    if (data == null) return;

    final updatedData = data.removePosition(categoryPath, positionIndex);
    emit(state.copyWith(performanceData: updatedData));
  }
}
