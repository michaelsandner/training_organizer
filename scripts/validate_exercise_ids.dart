import 'dart:convert';
import 'dart:io';

import 'package:training_organizer/features/exercise_plan/domain/exercise_type.dart';

void main() {
  final file = File('assets/data/exercises.json');
  if (!file.existsSync()) {
    stderr.writeln('Error: exercises.json not found');
    exit(1);
  }

  final content = file.readAsStringSync();
  final map = jsonDecode(content) as Map<String, dynamic>;
  final exercises = map['exercises'] as List<dynamic>;

  final ids = <int>{};
  final duplicates = <int>[];
  final invalidTypes = <String, int>{};

  for (final exercise in exercises) {
    final id = exercise['id'] as int;
    if (ids.contains(id)) {
      duplicates.add(id);
    }
    ids.add(id);

    final type = exercise['type'] as String?;
    if (type == null) {
      invalidTypes['null'] = id;
      continue;
    }
    try {
      ExerciseType.fromString(type);
    } catch (_) {
      invalidTypes[type] = id;
    }
  }

  if (duplicates.isNotEmpty) {
    stderr.writeln('Error: Duplicate exercise IDs found: $duplicates');
    exit(1);
  }

  if (invalidTypes.isNotEmpty) {
    stderr.writeln('Error: Invalid exercise types found:');
    invalidTypes.forEach((type, id) {
      stderr.writeln('  id $id: type "$type"');
    });
    exit(1);
  }

  stdout.writeln(
      'All ${exercises.length} exercise IDs are unique and all types are valid. Validation passed.');
}
