import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/performance_data/domain/performance_data.dart';

abstract interface class LocalStorageRepository {
  Future<List<Trainee>?> loadTrainees();
  Future<void> saveTrainees(List<Trainee> trainees);
  Future<PerformanceData?> loadPerformanceData();
  Future<void> savePerformanceData(PerformanceData data);
}
