import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/app_state.dart';
import 'package:training_organizer/trainee.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());

  void init() {
    emit(state.copyWith(selectedTrainees: state.trainees));
  }

  void updateTrainee(Trainee trainee) {
    // remove trainee from list
    var currentList = [...state.trainees];

    currentList.removeWhere((element) => element == trainee);

    // update group
    final updatedTrainee =
        trainee.copyWithNewGroup(getUpdatedGroup(trainee.trainingGroup!));

    // add to list
    currentList.add(updatedTrainee);

    emit(state.copyWith(
      trainees: currentList,
    ));
    // to update view
    setSelectedGroup(updatedTrainee.trainingGroup);
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
