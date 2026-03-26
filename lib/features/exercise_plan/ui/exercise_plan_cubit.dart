import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/data/local_storage_repository.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_plan_entry.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_repository.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_state.dart';

class ExercisePlanCubit extends Cubit<ExercisePlanState> {
  final ExerciseRepository _exerciseRepository;
  final LocalStorageRepository? _localStorageRepository;

  ExercisePlanCubit(
    this._exerciseRepository, {
    LocalStorageRepository? localStorageRepository,
  })  : _localStorageRepository = localStorageRepository,
        super(ExercisePlanState.initial());

  Future<void> init() async {
    final exercises = await _exerciseRepository.loadExercises();

    final savedEntries = await _localStorageRepository?.loadExercisePlan();

    List<ExercisePlanEntry> entries;
    if (savedEntries != null && savedEntries.isNotEmpty) {
      entries = savedEntries;
    } else {
      entries = _createDefaultEntries(exercises);
    }

    emit(state.copyWith(
      exercises: exercises,
      entries: entries,
      clearError: true,
    ));
  }

  List<ExercisePlanEntry> _createDefaultEntries(List<Exercise> exercises) {
    final defaultEntries = <ExercisePlanEntry>[];
    final types = ExerciseType.values;

    for (var i = 0; i < 5; i++) {
      final type = types[i % types.length];
      final exercisesForType =
          exercises.where((e) => e.type == type).toList();
      final exerciseId =
          exercisesForType.isNotEmpty ? exercisesForType.first.id : 1;
      defaultEntries.add(ExercisePlanEntry(
        type: type,
        selectedExerciseId: exerciseId,
      ));
    }

    return defaultEntries;
  }

  void updateEntryType(int index, ExerciseType type) {
    if (index < 0 || index >= state.entries.length) return;

    final exercisesForType =
        state.exercises.where((e) => e.type == type).toList();
    final exerciseId =
        exercisesForType.isNotEmpty ? exercisesForType.first.id : 1;

    final updatedEntries = List<ExercisePlanEntry>.from(state.entries);
    updatedEntries[index] = updatedEntries[index].copyWith(
      type: type,
      selectedExerciseId: exerciseId,
    );

    emit(state.copyWith(entries: updatedEntries, clearError: true));
    _saveExercisePlan(updatedEntries);
  }

  void updateEntryExercise(int index, int exerciseId) {
    if (index < 0 || index >= state.entries.length) return;

    final updatedEntries = List<ExercisePlanEntry>.from(state.entries);
    updatedEntries[index] = updatedEntries[index].copyWith(
      selectedExerciseId: exerciseId,
    );

    emit(state.copyWith(entries: updatedEntries, clearError: true));
    _saveExercisePlan(updatedEntries);
  }

  void updateEntryDistance(int index, int distance) {
    if (index < 0 || index >= state.entries.length) return;

    final updatedEntries = List<ExercisePlanEntry>.from(state.entries);
    updatedEntries[index] = updatedEntries[index].copyWith(
      distance: distance,
    );

    emit(state.copyWith(entries: updatedEntries, clearError: true));
    _saveExercisePlan(updatedEntries);
  }

  void addEntry() {
    const type = ExerciseType.einschwimmen;
    final exercisesForType =
        state.exercises.where((e) => e.type == type).toList();
    final exerciseId =
        exercisesForType.isNotEmpty ? exercisesForType.first.id : 1;

    final updatedEntries = List<ExercisePlanEntry>.from(state.entries)
      ..add(ExercisePlanEntry(
        type: type,
        selectedExerciseId: exerciseId,
      ));

    emit(state.copyWith(entries: updatedEntries, clearError: true));
    _saveExercisePlan(updatedEntries);
  }

  void removeEntry(int index) {
    if (index < 0 || index >= state.entries.length) return;

    final updatedEntries = List<ExercisePlanEntry>.from(state.entries)
      ..removeAt(index);

    emit(state.copyWith(entries: updatedEntries, clearError: true));
    _saveExercisePlan(updatedEntries);
  }

  void applyPlanString(String planString) {
    if (planString.isEmpty) {
      emit(state.copyWith(entries: const [], clearError: true));
      _saveExercisePlan(const []);
      return;
    }

    final pattern = RegExp(r'^\d+(-\d+)*$');
    if (!pattern.hasMatch(planString)) {
      emit(state.copyWith(
        errorMessage: 'Ungültiges Format. Erwartet: 1-2-3',
      ));
      return;
    }

    final ids = planString.split('-').map(int.parse).toList();
    final exerciseMap = {for (final e in state.exercises) e.id: e};

    for (final id in ids) {
      if (!exerciseMap.containsKey(id)) {
        emit(state.copyWith(
          errorMessage: 'Übung mit ID $id nicht gefunden',
        ));
        return;
      }
    }

    final updatedEntries = ids.map((id) {
      final exercise = exerciseMap[id]!;
      return ExercisePlanEntry(
        type: exercise.type,
        selectedExerciseId: id,
      );
    }).toList();

    emit(state.copyWith(entries: updatedEntries, clearError: true));
    _saveExercisePlan(updatedEntries);
  }

  void _saveExercisePlan(List<ExercisePlanEntry> entries) {
    final future = _localStorageRepository?.saveExercisePlan(entries);
    if (future != null) {
      unawaited(future);
    }
  }
}
