import 'package:training_organizer/features/exercise_plan/domain/exercise.dart';

abstract interface class ExerciseRepository {
  Future<List<Exercise>> loadExercises();
}
