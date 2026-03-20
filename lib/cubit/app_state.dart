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
  leisure,
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
  leisure,
}

@immutable
class AppState with EquatableMixin {
  final List<Trainee> trainees;

  const AppState({
    required this.trainees,
  });

  factory AppState.initial() {
    return const AppState(
      trainees: [],
    );
  }

  AppState copyWith({
    List<Trainee>? trainees,
  }) {
    return AppState(
      trainees: trainees ?? this.trainees,
    );
  }

  List<String> getAllEmailAdresses() {
    List<String> result = trainees.map((trainee) => trainee.email).toList();
    return result;
  }

  @override
  List<Object?> get props => [trainees];
}
