import 'package:training_organizer/cubit/app_state.dart';

class SelectableGroup {}

class All implements SelectableGroup {
  final FilterableGroup group;
  All({required this.group});
}

class TrainingGroup implements SelectableGroup {
  final String id;
  final String name;
  final String shortName;
  final Group group;
  final Group? nextGroup;
  final Group? lastGroup;

  TrainingGroup({
    required this.id,
    required this.name,
    required this.shortName,
    required this.group,
    this.nextGroup,
    this.lastGroup,
  });
}

final trainingGroups = [
  TrainingGroup(
    id: 'waitingList',
    name: 'Warteliste',
    shortName: 'w',
    group: Group.waitingList,
    nextGroup: Group.group5,
    lastGroup: Group.waitingList,
  ),
  TrainingGroup(
    id: 'group5',
    name: 'Block 5',
    shortName: '5',
    group: Group.group5,
    nextGroup: Group.group1,
    lastGroup: Group.waitingList,
  ),
  TrainingGroup(
    id: 'group1',
    name: 'Block 1',
    shortName: '1',
    group: Group.group1,
    nextGroup: Group.group2,
    lastGroup: Group.group5,
  ),
  TrainingGroup(
    id: 'group2',
    name: 'Block 2',
    shortName: '2',
    group: Group.group2,
    nextGroup: Group.group4,
    lastGroup: Group.group1,
  ),
  TrainingGroup(
    id: 'group3',
    name: 'Block 3',
    shortName: '3',
    group: Group.group3,
    nextGroup: Group.wednesday,
    lastGroup: Group.group4,
  ),
  TrainingGroup(
    id: 'group4',
    name: 'Block 4',
    shortName: '4',
    group: Group.group4,
    nextGroup: Group.group3,
    lastGroup: Group.group2,
  ),
  TrainingGroup(
    id: 'wednesday',
    name: 'Mittwoch',
    shortName: 'M',
    group: Group.wednesday,
    nextGroup: Group.active,
    lastGroup: Group.group4,
  ),
  TrainingGroup(
    id: 'active',
    name: 'Aktiv',
    shortName: 'A',
    group: Group.active,
    lastGroup: Group.wednesday,
  ),
];
