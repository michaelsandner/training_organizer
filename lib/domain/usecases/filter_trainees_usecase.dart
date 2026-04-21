import 'package:training_organizer/ui/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/model/training_group.dart';
import 'package:training_organizer/services/date_service.dart';

class FilterTraineesUseCase {
  List<Trainee> execute(
      List<Trainee> allTrainees, FilterableGroup? filterableGroup) {
    if (filterableGroup == null || filterableGroup == FilterableGroup.all) {
      return List.of(allTrainees);
    }

    final group = getGroup(filterableGroup);
    final filteredItems =
        allTrainees.where((element) => element.trainingGroup == group).toList();

    _sortTrainees(filterableGroup, filteredItems);

    return filteredItems;
  }

  void _sortTrainees(
      FilterableGroup filterableGroup, List<Trainee> trainees) {
    if (filterableGroup == FilterableGroup.waitingList) {
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

  String getNameForFilteredGroup(FilterableGroup? filterableGroup) {
    if (filterableGroup == null || filterableGroup == FilterableGroup.all) {
      return 'All';
    }

    final group = getGroup(filterableGroup);
    final current =
        trainingGroups.singleWhere((element) => element.group == group);
    return current.name;
  }
}
