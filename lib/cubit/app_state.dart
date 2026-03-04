import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:training_organizer/model/trainee.dart';

enum FilterableGroup {
  waitingList,
  invited,
  group1,
  group2,
  group3,
  group4,
  group5,
  wednesday,
  active,
  all,
}

enum Group {
  waitingList,
  invited,
  group1,
  group2,
  group3,
  group4,
  group5,
  wednesday,
  active,
}

@immutable
class AppState with EquatableMixin {
  final List<Trainee> trainees;
  final List<Trainee> selectedTrainees;

  final FilterableGroup selectedGroup;

  const AppState({
    required this.trainees,
    required this.selectedGroup,
    required this.selectedTrainees,
  });

  factory AppState.initial() {
    return const AppState(
      trainees: [],
      selectedGroup: FilterableGroup.all,
      selectedTrainees: [],
    );
  }

  AppState copyWith({
    List<Trainee>? trainees,
    FilterableGroup? selectedGroup,
    List<Trainee>? selectedTrainees,
    bool? showLoadingSpinner,
  }) {
    return AppState(
      trainees: trainees ?? this.trainees,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      selectedTrainees: selectedTrainees ?? this.selectedTrainees,
    );
  }

  List<String> getAllEmailAdresses() {
    List<String> result = trainees.map((trainee) => trainee.email).toList();
    return result;
  }

  @override
  List<Object?> get props => [
        trainees,
        selectedGroup,
        selectedTrainees,
      ];
}
