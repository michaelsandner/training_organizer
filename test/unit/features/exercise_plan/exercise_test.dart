import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/exercise.dart';
import 'package:training_organizer/domain/exercise_type.dart';

void main() {
  group('Exercise', () {
    group('Given a valid JSON map', () {
      group('When fromJson is called', () {
        test('Then an Exercise is created with correct fields', () {
          final json = {
            'id': 1,
            'name': 'Einschwimmen',
            'description': 'Schwimme x meter',
            'type': 'einschwimmen',
            'imageName': null,
            'unit': 'Meter',
          };

          final exercise = Exercise.fromJson(json);

          expect(exercise.id, 1);
          expect(exercise.name, 'Einschwimmen');
          expect(exercise.description, 'Schwimme x meter');
          expect(exercise.type, ExerciseType.einschwimmen);
          expect(exercise.imageName, isNull);
          expect(exercise.unit, 'Meter');
        });
      });
    });

    group('Given a JSON map with imageName', () {
      group('When fromJson is called', () {
        test('Then imageName is set', () {
          final json = {
            'id': 1,
            'name': 'Test',
            'description': 'desc',
            'type': 'technik-kraul',
            'imageName': 'test.png',
            'unit': 'Meter',
          };

          final exercise = Exercise.fromJson(json);

          expect(exercise.imageName, 'test.png');
        });
      });
    });

    group('Given an Exercise instance', () {
      group('When toJson is called', () {
        test('Then it returns the correct JSON map', () {
          const exercise = Exercise(
            id: 2,
            name: 'Kraul Beine',
            description: 'Schwimme nur Kraul Beine',
            type: ExerciseType.technikKraul,
            unit: 'Meter',
          );

          final json = exercise.toJson();

          expect(json['id'], 2);
          expect(json['name'], 'Kraul Beine');
          expect(json['description'], 'Schwimme nur Kraul Beine');
          expect(json['type'], 'technik-kraul');
          expect(json['imageName'], isNull);
          expect(json['unit'], 'Meter');
        });
      });
    });

    group('Given two exercises with same values', () {
      group('When compared for equality', () {
        test('Then they are equal', () {
          const exercise1 = Exercise(
            id: 1,
            name: 'Test',
            description: 'desc',
            type: ExerciseType.ausdauer,
            unit: 'Meter',
          );
          const exercise2 = Exercise(
            id: 1,
            name: 'Test',
            description: 'desc',
            type: ExerciseType.ausdauer,
            unit: 'Meter',
          );

          expect(exercise1, equals(exercise2));
        });
      });
    });
  });
}
