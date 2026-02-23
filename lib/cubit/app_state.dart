import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:training_organizer/model/qualifications.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
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
    return AppState(
      trainees: [
        Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '10.10.2000',
          registrationDate: '09.04.2023',
          phone: '01000 1100',
          trainingGroup: Group.waitingList,
          qualifications: Qualifications(qualifications: [
            Bronze(DateTime.now()),
          ]),
        ),
        Trainee(
          surname: 'Musterman',
          forename: 'Manuel',
          email: 'email@email.de',
          dateOfBirth: '10.10.2000',
          registrationDate: '09.04.2023',
          phone: '0000 000',
          trainingGroup: Group.group1,
        ),
        Trainee(
          surname: 'Musterman',
          forename: 'Mathilda',
          email: 'email@email.de',
          dateOfBirth: '10.10.2000',
          registrationDate: '09.04.2023',
          phone: '0100 023892',
          trainingGroup: Group.group2,
        )
      ],
      selectedGroup: FilterableGroup.all,
      selectedTrainees: List<Trainee>.empty(),
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
