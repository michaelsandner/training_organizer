import 'package:flutter/material.dart';

enum ExerciseType {
  einschwimmen,
  ausschwimmen,
  technik,
  spiel,
  ausdauer,
  kraft;

  String get displayName {
    switch (this) {
      case ExerciseType.einschwimmen:
        return 'Einschwimmen';
      case ExerciseType.ausschwimmen:
        return 'Ausschwimmen';
      case ExerciseType.technik:
        return 'Technik';
      case ExerciseType.spiel:
        return 'Spiel';
      case ExerciseType.ausdauer:
        return 'Ausdauer';
      case ExerciseType.kraft:
        return 'Kraft';
    }
  }

  Color get color {
    switch (this) {
      case ExerciseType.einschwimmen:
        return Colors.blue;
      case ExerciseType.ausschwimmen:
        return Colors.teal;
      case ExerciseType.technik:
        return Colors.orange;
      case ExerciseType.spiel:
        return Colors.green;
      case ExerciseType.ausdauer:
        return Colors.red;
      case ExerciseType.kraft:
        return Colors.purple;
    }
  }

  static ExerciseType fromString(String value) {
    return ExerciseType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown exercise type: $value'),
    );
  }
}
