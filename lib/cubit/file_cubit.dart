import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/file_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/services/file_service.dart';

class FileCubit extends Cubit<FileState> {
  FileCubit() : super(FileState.initial());

  void setShowLoadingIndicator(bool shouldShow) {
    emit(state.copyWith(showLoadingSpinner: shouldShow));
  }

  Future<List<Trainee>> loadFile() async {
    String? json = await FileService.importFile(setShowLoadingIndicator);

    if (json != null) {
      Map<String, dynamic> inputMap = jsonDecode(json);

      var list = inputMap['trainees'] as List;
      List<Trainee> traineeList = list.map((t) => Trainee.fromJson(t)).toList();

      return traineeList;
    }
    return [];
  }

  Future<void> saveFile(List<Trainee> trainees) async {
    Map<String, dynamic> map = {
      'trainees': trainees,
    };
    String json = jsonEncode(map);

    try {
      await FileService.exportFile(json);
      emit(state.copyWith(exportState: ExportState.exportSuccessful));
    } catch (e) {
      emit(state.copyWith(exportState: ExportState.exportFailed));
    } finally {
      emit(state.copyWith(exportState: ExportState.none));
    }
  }
}
