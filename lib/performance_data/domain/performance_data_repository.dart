import 'package:training_organizer/performance_data/domain/performance_data.dart';

abstract interface class PerformanceDataRepository {
  Future<PerformanceData?> importPerformanceData();
  Future<void> exportPerformanceData(PerformanceData data);
}
