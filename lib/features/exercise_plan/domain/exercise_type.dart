import 'package:flutter/material.dart';

enum ExerciseType {
  einschwimmen,
  anfaenger,
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
      case ExerciseType.anfaenger:
        return 'anfänger';
      case ExerciseType.rettungsschwimmen:
        return 'rettungsschwimmen';
      case ExerciseType.technikBrust:
        return 'technik-brust';
      case ExerciseType.technikKraul:
        return 'technik-kraul';
      case ExerciseType.technikRuecken:
        return 'technik-rücken';
      case ExerciseType.ausschwimmen:
        return 'ausschwimmen';
      case ExerciseType.spiel:
        return 'spiel';
      case ExerciseType.ausdauer:
        return 'ausdauer';
      case ExerciseType.kraft:
        return 'kraft';
    }
  }

  String get displayName {
    switch (this) {
      case ExerciseType.einschwimmen:
        return 'Einschwimmen';
      case ExerciseType.anfaenger:
        return 'Anfänger-Schwimmen';
      case ExerciseType.rettungsschwimmen:
        return 'Rettungsschwimmen';
      case ExerciseType.technikBrust:
        return 'Technik-Brust';
      case ExerciseType.technikKraul:
        return 'Technik-Kraul';
      case ExerciseType.technikRuecken:
        return 'Technik-Rücken';
      case ExerciseType.ausschwimmen:
        return 'Ausschwimmen';
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
      case ExerciseType.anfaenger:
        return Colors.lightBlueAccent;
      case ExerciseType.rettungsschwimmen:
        return Colors.cyan;
      case ExerciseType.technikBrust:
        return Colors.orange;
      case ExerciseType.technikKraul:
        return Colors.deepOrange;
      case ExerciseType.technikRuecken:
        return Colors.amber;
      case ExerciseType.ausschwimmen:
        return Colors.teal;
      case ExerciseType.spiel:
        return Colors.green;
      case ExerciseType.ausdauer:
        return Colors.red;
      case ExerciseType.kraft:
        return Colors.purple;
    }
  }

  static ExerciseType fromString(String value) {
    switch (value) {
      case 'einschwimmen':
        return ExerciseType.einschwimmen;
      case 'anfänger':
        return ExerciseType.anfaenger;
      case 'rettungsschwimmen':
        return ExerciseType.rettungsschwimmen;
      case 'technik-brust':
        return ExerciseType.technikBrust;
      case 'technik-kraul':
        return ExerciseType.technikKraul;
      case 'technik-rücken':
        return ExerciseType.technikRuecken;
      case 'ausschwimmen':
        return ExerciseType.ausschwimmen;
      case 'spiel':
        return ExerciseType.spiel;
      case 'ausdauer':
        return ExerciseType.ausdauer;
      case 'kraft':
        return ExerciseType.kraft;
      default:
        // fallback for legacy/enum names
        for (final type in ExerciseType.values) {
          if (type.name == value) return type;
        }
        throw ArgumentError('Unknown exercise type: $value');
    }
  }
}
