#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';

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

  for (final exercise in exercises) {
    final id = exercise['id'] as int;
    if (ids.contains(id)) {
      duplicates.add(id);
    }
    ids.add(id);
  }

  if (duplicates.isNotEmpty) {
    stderr.writeln('Error: Duplicate exercise IDs found: $duplicates');
    exit(1);
  }

  stdout.writeln(
      'All ${exercises.length} exercise IDs are unique. Validation passed.');
}
