import 'package:training_organizer/domain/exercise_plan/exercise_plan_collection.dart';

abstract interface class ExerciseCollectionRepository {
  Future<List<ExercisePlanCollection>?> importCollections();
  Future<void> exportCollections(
      List<ExercisePlanCollection> collections, String fileName);
}
