import 'package:flutter/material.dart';

enum ExerciseType {
  einschwimmen,
  wassergewoehnung,
  rettungsschwimmen,
  technikBrust,
  technikKraul,
  technikRuecken,
  ausschwimmen,
  spiel,
  ausdauer,
  kraft;

  /// Returns the canonical string for storage/serialization.
  String toStorageString() {
    switch (this) {
      case ExerciseType.einschwimmen:
        return 'einschwimmen';
      case ExerciseType.wassergewoehnung:
        return 'wassergewöhnung';
      case ExerciseType.technikBrust:
        return 'technik-brust';
      case ExerciseType.technikKraul:
        return 'technik-kraul';
      case ExerciseType.technikRuecken:
        return 'technik-rücken';
      case ExerciseType.rettungsschwimmen:
        return 'rettungsschwimmen';
      case ExerciseType.kraft:
        return 'kraft';
      case ExerciseType.ausdauer:
        return 'ausdauer';
      case ExerciseType.spiel:
        return 'spiel';
      case ExerciseType.ausschwimmen:
        return 'ausschwimmen';
    }
  }

  String get displayName {
    switch (this) {
      case ExerciseType.einschwimmen:
        return 'Einschwimmen';
      case ExerciseType.wassergewoehnung:
        return 'Wassergewöhnung';
      case ExerciseType.technikBrust:
        return 'Technik-Brust';
      case ExerciseType.technikKraul:
        return 'Technik-Kraul';
      case ExerciseType.technikRuecken:
        return 'Technik-Rücken';
      case ExerciseType.rettungsschwimmen:
        return 'Rettungsschwimmen';
      case ExerciseType.kraft:
        return 'Kraft';
      case ExerciseType.ausdauer:
        return 'Ausdauer';
      case ExerciseType.spiel:
        return 'Spiel';
      case ExerciseType.ausschwimmen:
        return 'Ausschwimmen';
    }
  }

  Color get color {
    switch (this) {
      case ExerciseType.einschwimmen:
        return Colors.orange;
      case ExerciseType.wassergewoehnung:
        return Colors.teal;
      case ExerciseType.technikBrust:
        return Colors.cyan;
      case ExerciseType.technikKraul:
        return Colors.cyan;
      case ExerciseType.technikRuecken:
        return Colors.cyan;
      case ExerciseType.rettungsschwimmen:
        return Colors.red;
      case ExerciseType.kraft:
        return Colors.purple;
      case ExerciseType.ausdauer:
        return Colors.purple;
      case ExerciseType.spiel:
        return Colors.green;
      case ExerciseType.ausschwimmen:
        return Colors.orange;
    }
  }

  static ExerciseType fromString(String value) {
    switch (value) {
      case 'einschwimmen':
        return ExerciseType.einschwimmen;
      case 'wassergewöhnung':
      case 'anfänger': // backward compatibility
        return ExerciseType.wassergewoehnung;
      case 'technik-brust':
        return ExerciseType.technikBrust;
      case 'technik-kraul':
        return ExerciseType.technikKraul;
      case 'technik-rücken':
        return ExerciseType.technikRuecken;
      case 'rettungsschwimmen':
        return ExerciseType.rettungsschwimmen;
      case 'kraft':
        return ExerciseType.kraft;
      case 'ausdauer':
        return ExerciseType.ausdauer;
      case 'spiel':
        return ExerciseType.spiel;
      case 'ausschwimmen':
        return ExerciseType.ausschwimmen;
      default:
        // fallback for legacy/enum names
        for (final type in ExerciseType.values) {
          if (type.name == value) return type;
        }
        throw ArgumentError('Unknown exercise type: $value');
    }
  }
}
