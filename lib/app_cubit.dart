import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/app_state.dart';
import 'package:training_organizer/file_service.dart';
import 'package:training_organizer/trainee.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());

  void init() {
    emit(state.copyWith(selectedTrainees: state.trainees));
  }

  void addTrainee(Trainee trainee) {
    final updatedTraineeList = [...state.trainees];

    if (state.trainees.contains(trainee)) {
      return;
    }
    updatedTraineeList.add(trainee);

    emit(state.copyWith(trainees: updatedTraineeList));
    setSelectedGroup(Group.all);
  }

  void editTrainee(Trainee trainee, String? newPhone, String? newEmail) {
    final selectedGrouop = state.selectedGroup;
    List<Trainee> updatedTraineeList = [...state.trainees];
    updatedTraineeList.removeWhere((element) => element == trainee);
    updatedTraineeList.add(trainee.copyWith(phone: newPhone, email: newEmail));
    emit(state.copyWith(trainees: updatedTraineeList));
    setSelectedGroup(Group.active);
    setSelectedGroup(selectedGrouop);
  }

  bool isDowngradePossible(Trainee trainee) {
    return trainee.trainingGroup != Group.waitingList &&
        trainee.trainingGroup != Group.group5;
  }

  bool isUpgradePossible(Trainee trainee) {
    return trainee.trainingGroup != Group.active;
  }

  void upgradeTrainee(Trainee trainee) {
    final currentList = [...state.trainees];

    currentList.removeWhere((element) => element == trainee);

    final updatedTrainee =
        trainee.copyWithNewGroup(getUpgradedGroup(trainee.trainingGroup!));

    currentList.add(updatedTrainee);

    emit(state.copyWith(
      trainees: currentList,
    ));
    setSelectedGroup(updatedTrainee.trainingGroup);
  }

  void downgradeTrainee(Trainee trainee) {
    var currentList = [...state.trainees];

    currentList.removeWhere((element) => element == trainee);

    final updatedTrainee =
        trainee.copyWithNewGroup(getDowngradedGroup(trainee.trainingGroup!));

    currentList.add(updatedTrainee);

    emit(state.copyWith(
      trainees: currentList,
    ));
    setSelectedGroup(updatedTrainee.trainingGroup);
  }

  Future<void> loadFile() async {
    String? json = await FileService.importFile();

    if (json != null) {
      Map<String, dynamic> inputMap = jsonDecode(json);

      var list = inputMap['trainees'] as List;
      List<Trainee> traineeList = list.map((t) => Trainee.fromJson(t)).toList();

      emit(state.copyWith(trainees: traineeList));
      setSelectedGroup(Group.all);
    }
  }

  Future<void> saveFile() async {
    Map<String, dynamic> map = {
      'trainees': state.trainees,
    };
    String json = jsonEncode(map);

    await FileService.exportFile(json);
  }

  Group getUpgradedGroup(Group currentGroup) {
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
      case Group.wednesday:
        return Group.active;
      default:
        return currentGroup;
    }
  }

  Group getDowngradedGroup(Group currentGroup) {
    switch (currentGroup) {
      case Group.active:
        return Group.wednesday;
      case Group.wednesday:
        return Group.group3;
      case Group.group3:
        return Group.group4;
      case Group.group4:
        return Group.group2;
      case Group.group2:
        return Group.group1;
      case Group.group1:
        return Group.group5;

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

      if (selectedValue != Group.waitingList) {
        filteredItems.sort((a, b) => a.surname.compareTo(b.surname));
      }

      emit(state.copyWith(
          selectedGroup: selectedValue, selectedTrainees: filteredItems));
    }
  }

  String getSelectedGroupName() {
    switch (state.selectedGroup) {
      case Group.group1:
        return 'Block 1';
      case Group.group2:
        return 'Block 2';
      case Group.group3:
        return 'Block 3';
      case Group.group4:
        return 'Block 4';
      case Group.group5:
        return 'Block 5';
      case Group.wednesday:
        return 'Mittwoch';
      case Group.active:
        return "Aktiv";
      case Group.waitingList:
        return 'Warteliste';
      case Group.all:
        return 'All';
      default:
        return 'null';
    }
  }
}
