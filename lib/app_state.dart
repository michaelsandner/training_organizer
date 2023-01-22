import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:training_organizer/trainee.dart';

enum Group {
  waitingList,
  group1,
  group2,
  group3,
  group4,
  group5,
  wednesday,
  all,
}

@immutable
class AppState with EquatableMixin {
  final List<Trainee> trainees;
  final List<Trainee> selectedTrainees;

  final Group? selectedGroup;

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
          dateOfBirth: '2000-10-10',
          phone: '01000 1100',
          trainingGroup: Group.waitingList,
        ),
        Trainee(
          surname: 'Musterman',
          forename: 'Manuel',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          phone: '0000 000',
          trainingGroup: Group.group1,
        ),
        Trainee(
          surname: 'Musterman',
          forename: 'Mathilda',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          phone: '0100 023892',
          trainingGroup: Group.group2,
        )
      ],
      selectedGroup: Group.all,
      selectedTrainees: List<Trainee>.empty(),
    );
  }

  AppState copyWith({
    List<Trainee>? trainees,
    Group? selectedGroup,
    List<Trainee>? selectedTrainees,
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
        trainees.last.trainingGroup,
        selectedGroup,
        selectedTrainees,
      ];
}
