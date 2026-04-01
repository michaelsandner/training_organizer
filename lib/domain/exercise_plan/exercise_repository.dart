import 'package:training_organizer/domain/exercise_plan/exercise.dart';

abstract interface class ExerciseRepository {
  Future<List<Exercise>> loadExercises();
}
