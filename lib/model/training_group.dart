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
  final FilterableGroup group;
  final FilterableGroup? nextGroup;
  final FilterableGroup? lastGroup;

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
    group: FilterableGroup.waitingList,
    nextGroup: FilterableGroup.group5,
    lastGroup: FilterableGroup.waitingList,
  ),
  TrainingGroup(
    id: 'group5',
    name: 'Block 5',
    shortName: '5',
    group: FilterableGroup.group5,
    nextGroup: FilterableGroup.group1,
    lastGroup: FilterableGroup.waitingList,
  ),
  TrainingGroup(
    id: 'group1',
    name: 'Block 1',
    shortName: '1',
    group: FilterableGroup.group1,
    nextGroup: FilterableGroup.group2,
    lastGroup: FilterableGroup.group5,
  ),
  TrainingGroup(
    id: 'group2',
    name: 'Block 2',
    shortName: '2',
    group: FilterableGroup.group2,
    nextGroup: FilterableGroup.group4,
    lastGroup: FilterableGroup.group1,
  ),
  TrainingGroup(
    id: 'group3',
    name: 'Block 3',
    shortName: '3',
    group: FilterableGroup.group3,
    nextGroup: FilterableGroup.wednesday,
    lastGroup: FilterableGroup.group4,
  ),
  TrainingGroup(
    id: 'group4',
    name: 'Block 4',
    shortName: '4',
    group: FilterableGroup.group4,
    nextGroup: FilterableGroup.group3,
    lastGroup: FilterableGroup.group2,
  ),
  TrainingGroup(
    id: 'wednesday',
    name: 'Mittwoch',
    shortName: 'M',
    group: FilterableGroup.wednesday,
    nextGroup: FilterableGroup.active,
    lastGroup: FilterableGroup.group4,
  ),
  TrainingGroup(
    id: 'active',
    name: 'Aktiv',
    shortName: 'A',
    group: FilterableGroup.active,
    lastGroup: FilterableGroup.wednesday,
  ),
];
