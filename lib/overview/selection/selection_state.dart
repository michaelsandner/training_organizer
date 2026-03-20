import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';

@immutable
class SelectionState with EquatableMixin {
  final List<Trainee> selectedTrainees;
  final FilterableGroup selectedGroup;

  const SelectionState({
    required this.selectedTrainees,
    required this.selectedGroup,
  });

  factory SelectionState.initial() {
    return const SelectionState(
      selectedTrainees: [],
      selectedGroup: FilterableGroup.all,
    );
  }

  SelectionState copyWith({
    List<Trainee>? selectedTrainees,
    FilterableGroup? selectedGroup,
  }) {
    return SelectionState(
      selectedTrainees: selectedTrainees ?? this.selectedTrainees,
      selectedGroup: selectedGroup ?? this.selectedGroup,
    );
  }

  @override
  List<Object?> get props => [selectedTrainees, selectedGroup];
}
