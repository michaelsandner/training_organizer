import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/app_state.dart';
import 'package:training_organizer/trainee.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());

  void init() {
    emit(state.copyWith(selectedTrainees: state.trainees));
  }

  void updateTrainee(Trainee trainee) {
    var currentList = [...state.trainees];

    currentList.removeWhere((element) => element == trainee);

    final updatedTrainee =
        trainee.copyWithNewGroup(getUpdatedGroup(trainee.trainingGroup!));

    currentList.add(updatedTrainee);

    emit(state.copyWith(
      trainees: currentList,
    ));
    setSelectedGroup(updatedTrainee.trainingGroup);
  }

  Future<void> loadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);

      String jsonString = await file.readAsString();
      Map<String, dynamic> inputMap = jsonDecode(jsonString);

      var list = inputMap['trainees'] as List;
      List<Trainee> traineeList = list.map((t) => Trainee.fromJson(t)).toList();

      emit(state.copyWith(trainees: traineeList));
      setSelectedGroup(Group.all);
    }
  }

  Future<void> saveFile() async {
    String localPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    File saveFile = File('$localPath/t.json');

    Map<String, dynamic> map = {
      'trainees': state.trainees,
    };
    String json = jsonEncode(map);

    await saveFile.writeAsString(json);
  }

  Group getUpdatedGroup(Group currentGroup) {
    switch (currentGroup) {
      case Group.waitingList:
        return Group.group5;
      case Group.group5:
        return Group.group1;
      case Group.group1:
        return Group.group2;
      case Group.group2:
        return Group.group4;
      case Group.group4:
        return Group.group3;
      case Group.group3:
        return Group.wednesday;
      default:
        return currentGroup;
    }
  }

  void setSelectedGroup(Group? selectedValue) {
    if (selectedValue == Group.all) {
      emit(state.copyWith(
          selectedGroup: selectedValue, selectedTrainees: state.trainees));
    } else {
      final filteredItems = state.trainees
          .where((element) => element.trainingGroup == selectedValue)
          .toList();

      emit(state.copyWith(
          selectedGroup: selectedValue, selectedTrainees: filteredItems));
    }
  }
}
