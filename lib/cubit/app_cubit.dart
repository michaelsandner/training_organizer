import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/email/domain/send_email_usecase.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/model/training_group.dart';
import 'package:training_organizer/services/date_service.dart';

class AppCubit extends Cubit<AppState> {
  final SendEmailUseCase _sendEmailUseCase;
  AppCubit(this._sendEmailUseCase) : super(AppState.initial());

  void init() {
    emit(state.copyWith(selectedTrainees: state.trainees));
  }

  void updateTraineeList(List<Trainee> trainees) {
    emit(state.copyWith(trainees: trainees));
    setSelectedGroup(FilterableGroup.all);
  }

  void processTrainee(Trainee? oldTrainee, Trainee newTrainee) {
    if (oldTrainee == null) {
      addTrainee(newTrainee);
    } else {
      replaceTrainee(oldTrainee, newTrainee);
    }
  }

  void addTrainee(Trainee trainee) {
    final updatedTraineeList = [...state.trainees];

    if (state.trainees.contains(trainee)) {
      return;
    }
    updatedTraineeList.add(trainee);

    emit(state.copyWith(trainees: updatedTraineeList));
    setSelectedGroup(FilterableGroup.all);
  }

  void removeTrainee(Trainee trainee) {
    final selectedGroup = state.selectedGroup;
    final updatedTraineeList = [...state.trainees];
    updatedTraineeList.removeWhere((element) => element == trainee);
    emit(state.copyWith(trainees: updatedTraineeList));
    setSelectedGroup(selectedGroup);
  }

  void replaceTrainee(Trainee oldTrainee, Trainee newTrainee) {
    final selectedGroup = state.selectedGroup;
    final updatedTraineeList = [...state.trainees];
    updatedTraineeList.removeWhere((element) => element == oldTrainee);
    updatedTraineeList.add(newTrainee);
    emit(state.copyWith(trainees: updatedTraineeList));
    setSelectedGroup(selectedGroup);
  }

  bool isDowngradePossible(Trainee trainee) {
    return trainee.trainingGroup != Group.waitingList &&
        trainee.trainingGroup != Group.group5;
  }

  bool isUpgradePossible(Trainee trainee) {
    return trainee.trainingGroup != Group.active;
  }

  void upgradeTrainee(Trainee trainee) {
    _changeTraineeGroup(trainee, getUpgradedGroup(trainee.trainingGroup));
  }

  void downgradeTrainee(Trainee trainee) {
    _changeTraineeGroup(trainee, getDowngradedGroup(trainee.trainingGroup));
  }

  void _changeTraineeGroup(Trainee trainee, Group newGroup) {
    final currentList = [...state.trainees];

    currentList.removeWhere((element) => element == trainee);
    currentList.add(trainee.copyWithNewGroup(newGroup));

    emit(state.copyWith(trainees: currentList));
    setSelectedGroup(getFilteredGroup(newGroup));
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

  void setSelectedGroup(FilterableGroup? selectedValue) {
    if (selectedValue == null || selectedValue == FilterableGroup.all) {
      emit(state.copyWith(
          selectedGroup: selectedValue, selectedTrainees: state.trainees));
    } else {
      final filteredItems = state.trainees
          .where((element) => element.trainingGroup == getGroup(selectedValue))
          .toList();

      _sortTrainees(selectedValue, filteredItems);

      emit(state.copyWith(
          selectedGroup: selectedValue, selectedTrainees: filteredItems));
    }
  }

  void _sortTrainees(FilterableGroup selectedValue, List<Trainee> trainees) {
    if (selectedValue != FilterableGroup.waitingList) {
      _sortBySurename(trainees);
    }

    if (selectedValue == FilterableGroup.waitingList) {
      _sortByRegistrationDate(trainees);
    }
  }

  void _sortBySurename(List<Trainee> trainees) {
    trainees.sort((a, b) => a.surname.compareTo(b.surname));
  }

  void _sortByRegistrationDate(List<Trainee> trainees) {
    trainees.sort((a, b) => DateService.parseToDate(a.registrationDate)
        .compareTo(DateService.parseToDate(b.registrationDate)));
  }

  FilterableGroup getFilteredGroup(Group group) {
    switch (group) {
      case Group.waitingList:
        return FilterableGroup.waitingList;
      case Group.invited:
        return FilterableGroup.invited;
      case Group.group1:
        return FilterableGroup.group1;
      case Group.group2:
        return FilterableGroup.group2;
      case Group.group3:
        return FilterableGroup.group3;
      case Group.group4:
        return FilterableGroup.group4;
      case Group.group5:
        return FilterableGroup.group5;
      case Group.wednesday:
        return FilterableGroup.wednesday;
      case Group.active:
        return FilterableGroup.active;
    }
  }

  Group getGroup(FilterableGroup filterableGroup) {
    switch (filterableGroup) {
      case FilterableGroup.waitingList:
        return Group.waitingList;
      case FilterableGroup.invited:
        return Group.invited;
      case FilterableGroup.group1:
        return Group.group1;
      case FilterableGroup.group2:
        return Group.group2;
      case FilterableGroup.group3:
        return Group.group3;
      case FilterableGroup.group4:
        return Group.group4;
      case FilterableGroup.group5:
        return Group.group5;
      case FilterableGroup.wednesday:
        return Group.wednesday;
      case FilterableGroup.active:
        return Group.active;
      default:
        return Group.waitingList;
    }
  }

  String getSelectedGroupName() {
    return getNameForFilteredGroupEnum(state.selectedGroup);
  }

  String getNameForFilteredGroupEnum(FilterableGroup? filterableGroup) {
    if (filterableGroup == null || filterableGroup == FilterableGroup.all) {
      return 'All';
    }

    final group = getGroup(filterableGroup);

    final current =
        trainingGroups.singleWhere((element) => element.group == group);
    return current.name;
  }

  String getNameForGroupEnum(Group? group) {
    final current =
        trainingGroups.singleWhere((element) => element.group == group);
    return current.name;
  }

  Future<void> sendMailToTrainee(Trainee trainee) async {
    if (state.selectedGroup == FilterableGroup.waitingList) {
      await _sendEmailUseCase.sendEmailToSingleWaitingListTrainee(trainee);
    } else {
      await _sendEmailUseCase.sendEmailToSingleTrainee(trainee);
    }
  }
}
