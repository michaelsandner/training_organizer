import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/model/training_group.dart';
import 'package:training_organizer/services/file_service.dart';

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
    final current =
        trainingGroups.singleWhere((element) => element.group == currentGroup);
    if (current.nextGroup == null) {
      return currentGroup;
    }
    return current.nextGroup!;
  }

  Group getDowngradedGroup(Group currentGroup) {
    final current =
        trainingGroups.singleWhere((element) => element.group == currentGroup);
    if (current.lastGroup == null) {
      return currentGroup;
    }
    return current.lastGroup!;
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
    return getEnumGroupName(state.selectedGroup);
  }

  String getEnumGroupName(Group? group) {
    if (group == null || group == Group.all) {
      return 'All';
    }
    final current =
        trainingGroups.singleWhere((element) => element.group == group);
    return current.name;
  }
}
