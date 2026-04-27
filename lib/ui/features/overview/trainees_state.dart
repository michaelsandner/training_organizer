import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:training_organizer/model/trainee.dart';

enum FilterableGroup {
  waitingList,
  invited,
  group1,
  group2,
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
  group4,
  group5,
  wednesday,
  active,
  leisure,
}

@immutable
class TraineesState with EquatableMixin {
  final List<Trainee> trainees;

  const TraineesState({
    required this.trainees,
  });

  factory TraineesState.initial() {
    return const TraineesState(
      trainees: [],
    );
  }

  TraineesState copyWith({
    List<Trainee>? trainees,
  }) {
    return TraineesState(
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
