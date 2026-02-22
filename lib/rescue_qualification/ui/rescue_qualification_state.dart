import 'package:equatable/equatable.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';

class RescueQualificationState with EquatableMixin {
  final FilterableGroup selectedFilter;
  final Set<Trainee> selectedTrainees;

  const RescueQualificationState({
    required this.selectedFilter,
    required this.selectedTrainees,
  });

  factory RescueQualificationState.initial() {
    return const RescueQualificationState(
      selectedFilter: FilterableGroup.wednesday,
      selectedTrainees: {},
    );
  }

  RescueQualificationState copyWith({
    FilterableGroup? selectedFilter,
    Set<Trainee>? selectedTrainees,
  }) {
    return RescueQualificationState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedTrainees: selectedTrainees ?? this.selectedTrainees,
    );
  }

  @override
  List<Object?> get props => [selectedFilter, selectedTrainees];
}
