import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_collection.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_entry.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/domain/performance_data/performance_data.dart';
import 'package:training_organizer/data/local_storage_repository.dart';

class LocalStorageService implements LocalStorageRepository {
  static const String _traineesKey = 'trainees';
  static const String _performanceDataKey = 'performance_data';
  static const String _exercisePlanKey = 'exercise_plan';
  static const String _exerciseCollectionsKey = 'exercise_collections';

  @override
  Future<List<Trainee>?> loadTrainees() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_traineesKey);
    if (json == null) return null;

    final map = jsonDecode(json) as Map<String, dynamic>;
    final list = map['trainees'] as List<dynamic>;
    return list.map((t) => Trainee.fromJson(t)).toList();
  }

  @override
  Future<void> saveTrainees(List<Trainee> trainees) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'trainees': trainees.map((t) => t.toJson()).toList(),
    };
    await prefs.setString(_traineesKey, jsonEncode(map));
  }

  @override
  Future<PerformanceData?> loadPerformanceData() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_performanceDataKey);
    if (json == null) return null;

    final map = jsonDecode(json) as Map<String, dynamic>;
    return PerformanceData.fromJson(map);
  }

  @override
  Future<void> savePerformanceData(PerformanceData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_performanceDataKey, jsonEncode(data.toJson()));
  }

  @override
  Future<List<ExercisePlanEntry>?> loadExercisePlan() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_exercisePlanKey);
    if (json == null) return null;

    final map = jsonDecode(json) as Map<String, dynamic>;
    final list = map['entries'] as List<dynamic>;
    return list
        .map((e) => ExercisePlanEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveExercisePlan(List<ExercisePlanEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'entries': entries.map((e) => e.toJson()).toList(),
    };
    await prefs.setString(_exercisePlanKey, jsonEncode(map));
  }

  @override
  Future<List<ExercisePlanCollection>?> loadExerciseCollections() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_exerciseCollectionsKey);
    if (json == null) return null;

    final map = jsonDecode(json) as Map<String, dynamic>;
    final list = map['collections'] as List<dynamic>;
    return list
        .map((e) => ExercisePlanCollection.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveExerciseCollections(
      List<ExercisePlanCollection> collections) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'collections': collections.map((c) => c.toJson()).toList(),
    };
    await prefs.setString(_exerciseCollectionsKey, jsonEncode(map));
  }
}
