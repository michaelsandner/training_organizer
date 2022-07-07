import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:training_organizer/trainee.dart';

@immutable
class AppState with EquatableMixin {
  final List<Trainee> trainees;

  const AppState({
    required this.trainees,
  });

  factory AppState.initial() {
    return AppState(trainees: List<Trainee>.empty());
  }

  AppState copyWith({
    List<Trainee>? trainees,
  }) {
    return AppState(trainees: trainees ?? this.trainees);
  }

  List<String> getAllEmailAdresses() {
    List<String> result = trainees.map((trainee) => trainee.email).toList();
    return result;
  }

  @override
  List<Object?> get props => [trainees];
}
