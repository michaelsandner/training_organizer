import 'package:training_organizer/domain/performance_data/performance_data.dart';

abstract interface class PerformanceDataRepository {
  Future<PerformanceData?> importPerformanceData();
  Future<void> exportPerformanceData(PerformanceData data);
}
