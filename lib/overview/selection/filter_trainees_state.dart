import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:training_organizer/cubit/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';

@immutable
class FilterTraineesState with EquatableMixin {
  final List<Trainee> selectedTrainees;
  final FilterableGroup selectedGroup;

  const FilterTraineesState({
    required this.selectedTrainees,
    required this.selectedGroup,
  });

  factory FilterTraineesState.initial() {
    return const FilterTraineesState(
      selectedTrainees: [],
      selectedGroup: FilterableGroup.all,
    );
  }

  FilterTraineesState copyWith({
    List<Trainee>? selectedTrainees,
    FilterableGroup? selectedGroup,
  }) {
    return FilterTraineesState(
      selectedTrainees: selectedTrainees ?? this.selectedTrainees,
      selectedGroup: selectedGroup ?? this.selectedGroup,
    );
  }

  @override
  List<Object?> get props => [selectedTrainees, selectedGroup];
}
