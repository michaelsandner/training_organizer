import 'package:equatable/equatable.dart';
import 'package:training_organizer/domain/exercise_type.dart';

class ExercisePlanEntry with EquatableMixin {
  final ExerciseType type;
  final int selectedExerciseId;
  final int distance;

  const ExercisePlanEntry({
    required this.type,
    required this.selectedExerciseId,
    this.distance = 50,
  });

  ExercisePlanEntry copyWith({
    ExerciseType? type,
    int? selectedExerciseId,
    int? distance,
  }) {
    return ExercisePlanEntry(
      type: type ?? this.type,
      selectedExerciseId: selectedExerciseId ?? this.selectedExerciseId,
      distance: distance ?? this.distance,
    );
  }

  factory ExercisePlanEntry.fromJson(Map<String, dynamic> json) {
    return ExercisePlanEntry(
      type: ExerciseType.fromString(json['type'] as String),
      selectedExerciseId: json['selectedExerciseId'] as int,
      distance: json['distance'] as int? ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toStorageString(),
      'selectedExerciseId': selectedExerciseId,
      'distance': distance,
    };
  }

  @override
  List<Object?> get props => [type, selectedExerciseId, distance];
}
