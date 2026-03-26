import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_repository.dart';

class ExerciseDataRepository implements ExerciseRepository {
  @override
  Future<List<Exercise>> loadExercises() async {
    final jsonString =
        await rootBundle.loadString('assets/data/exercises.json');
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = map['exercises'] as List<dynamic>;
    return list
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
