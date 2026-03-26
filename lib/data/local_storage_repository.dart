import 'package:training_organizer/features/exercise_plan/domain/exercise_plan_entry.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/domain/performance_data.dart';

abstract interface class LocalStorageRepository {
  Future<List<Trainee>?> loadTrainees();
  Future<void> saveTrainees(List<Trainee> trainees);
  Future<PerformanceData?> loadPerformanceData();
  Future<void> savePerformanceData(PerformanceData data);
  Future<List<ExercisePlanEntry>?> loadExercisePlan();
  Future<void> saveExercisePlan(List<ExercisePlanEntry> entries);
}
