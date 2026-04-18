import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/data/local_storage_repository.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_collection_repository.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_collection.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_collection_state.dart';

class ExerciseCollectionCubit extends Cubit<ExerciseCollectionState> {
  final LocalStorageRepository _localStorageRepository;
  final ExerciseCollectionRepository _fileHandler;

  ExerciseCollectionCubit(
    this._localStorageRepository,
    this._fileHandler,
  ) : super(ExerciseCollectionState.initial());

  Future<void> init() async {
    final collections =
        await _localStorageRepository.loadExerciseCollections();
    emit(state.copyWith(
      collections: collections ?? [],
      clearError: true,
    ));
  }

  Future<void> saveCollection(String name, String planString) async {
    final collection = ExercisePlanCollection(
      name: name,
      planString: planString,
    );
    final updatedCollections =
        List<ExercisePlanCollection>.from(state.collections)..add(collection);
    await _localStorageRepository.saveExerciseCollections(updatedCollections);
    emit(state.copyWith(collections: updatedCollections, clearError: true));
  }

  Future<void> deleteCollection(int index) async {
    if (index < 0 || index >= state.collections.length) return;
    final updatedCollections =
        List<ExercisePlanCollection>.from(state.collections)..removeAt(index);
    await _localStorageRepository.saveExerciseCollections(updatedCollections);
    emit(state.copyWith(collections: updatedCollections, clearError: true));
  }

  Future<void> exportCollections(String fileName) async {
    try {
      await _fileHandler.exportCollections(state.collections, fileName);
    } catch (e) {
      emit(state.copyWith(
          errorMessage: 'Export fehlgeschlagen: ${e.toString()}'));
    }
  }

  Future<void> importCollections() async {
    try {
      final collections = await _fileHandler.importCollections();
      if (collections == null) return;
      await _localStorageRepository.saveExerciseCollections(collections);
      emit(state.copyWith(collections: collections, clearError: true));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: 'Import fehlgeschlagen: ${e.toString()}'));
    }
  }
}
