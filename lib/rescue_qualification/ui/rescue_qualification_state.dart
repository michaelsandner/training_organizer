import 'package:equatable/equatable.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';

enum RescueQualificationType { bronze, silber, gold }

class RescueQualificationState with EquatableMixin {
  final FilterableGroup selectedFilter;
  final Set<Trainee> selectedTrainees;
  final RescueQualificationType selectedQualification;

  const RescueQualificationState({
    required this.selectedFilter,
    required this.selectedTrainees,
    required this.selectedQualification,
  });

  factory RescueQualificationState.initial() {
    return const RescueQualificationState(
      selectedFilter: FilterableGroup.wednesday,
      selectedTrainees: {},
      selectedQualification: RescueQualificationType.bronze,
    );
  }

  RescueQualificationState copyWith({
    FilterableGroup? selectedFilter,
    Set<Trainee>? selectedTrainees,
    RescueQualificationType? selectedQualification,
  }) {
    return RescueQualificationState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedTrainees: selectedTrainees ?? this.selectedTrainees,
      selectedQualification:
          selectedQualification ?? this.selectedQualification,
    );
  }

  @override
  List<Object?> get props =>
      [selectedFilter, selectedTrainees, selectedQualification];
}
