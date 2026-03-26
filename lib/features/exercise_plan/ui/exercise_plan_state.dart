import 'package:equatable/equatable.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_plan_entry.dart';

class ExercisePlanState with EquatableMixin {
  final List<Exercise> exercises;
  final List<ExercisePlanEntry> entries;
  final String? errorMessage;

  const ExercisePlanState({
    this.exercises = const [],
    this.entries = const [],
    this.errorMessage,
  });

  factory ExercisePlanState.initial() {
    return const ExercisePlanState();
  }

  String get planString {
    return entries.map((e) => e.selectedExerciseId).join('-');
  }

  ExercisePlanState copyWith({
    List<Exercise>? exercises,
    List<ExercisePlanEntry>? entries,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ExercisePlanState(
      exercises: exercises ?? this.exercises,
      entries: entries ?? this.entries,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [exercises, entries, errorMessage];
}
