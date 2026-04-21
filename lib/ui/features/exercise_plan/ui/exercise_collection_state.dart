import 'package:equatable/equatable.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_collection.dart';

class ExerciseCollectionState with EquatableMixin {
  final List<ExercisePlanCollection> collections;
  final String? errorMessage;

  const ExerciseCollectionState({
    this.collections = const [],
    this.errorMessage,
  });

  factory ExerciseCollectionState.initial() {
    return const ExerciseCollectionState();
  }

  ExerciseCollectionState copyWith({
    List<ExercisePlanCollection>? collections,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ExerciseCollectionState(
      collections: collections ?? this.collections,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [collections, errorMessage];
}
