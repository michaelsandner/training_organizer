import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/domain/performance_data.dart';
import 'package:training_organizer/data/local_storage_repository.dart';

class LocalStorageService implements LocalStorageRepository {
  static const String _traineesKey = 'trainees';
  static const String _performanceDataKey = 'performance_data';

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
}
