import 'package:training_organizer/domain/exercise.dart';

abstract interface class ExerciseRepository {
  Future<List<Exercise>> loadExercises();
}
