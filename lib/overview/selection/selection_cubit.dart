import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/model/training_group.dart';
import 'package:training_organizer/overview/selection/selection_state.dart';
import 'package:training_organizer/services/date_service.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit() : super(SelectionState.initial());

  void setSelectedGroup(
      FilterableGroup? selectedValue, List<Trainee> allTrainees) {
    if (selectedValue == null || selectedValue == FilterableGroup.all) {
      emit(state.copyWith(
        selectedGroup: selectedValue ?? FilterableGroup.all,
        selectedTrainees: allTrainees,
      ));
    } else {
      final filteredItems = allTrainees
          .where((element) => element.trainingGroup == getGroup(selectedValue))
          .toList();

      _sortTrainees(selectedValue, filteredItems);

      emit(state.copyWith(
        selectedGroup: selectedValue,
        selectedTrainees: filteredItems,
      ));
    }
  }

  void _sortTrainees(FilterableGroup selectedValue, List<Trainee> trainees) {
    if (selectedValue == FilterableGroup.waitingList) {
      _sortByRegistrationDate(trainees);
    } else {
      _sortBySurname(trainees);
    }
  }

  void _sortBySurname(List<Trainee> trainees) {
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
      case Group.leisure:
        return FilterableGroup.leisure;
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
      case FilterableGroup.leisure:
        return Group.leisure;
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
}
