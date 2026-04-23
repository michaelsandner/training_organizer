import 'package:training_organizer/domain/repositories/exercise_collection_repository.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_collection.dart';

class MockExerciseCollectionFileHandler
    implements ExerciseCollectionRepository {
  List<ExercisePlanCollection>? _lastExportedCollections;
  List<ExercisePlanCollection>? _importData;
  String? _lastExportedFileName;

  List<ExercisePlanCollection>? get lastExportedCollections =>
      _lastExportedCollections;
  String? get lastExportedFileName => _lastExportedFileName;

  void setImportData(List<ExercisePlanCollection> data) {
    _importData = List<ExercisePlanCollection>.from(data);
  }

  @override
  Future<void> exportCollections(
      List<ExercisePlanCollection> collections, String fileName) async {
    _lastExportedCollections =
        List<ExercisePlanCollection>.from(collections);
    _lastExportedFileName = fileName;
  }

  @override
  Future<List<ExercisePlanCollection>?> importCollections() async {
    final data = _importData ?? _lastExportedCollections;
    if (data == null) return null;
    return List<ExercisePlanCollection>.from(data);
  }
}
