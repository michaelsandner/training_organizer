import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';

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
          expect(exercise.link, isNull);
          expect(exercise.unit, 'Meter');
          expect(exercise.material, isNull);
          expect(exercise.varianten, isNull);
        });
      });
    });

    group('Given a JSON map with material and varianten', () {
      group('When fromJson is called', () {
        test('Then material and varianten are set', () {
          final json = {
            'id': 1,
            'name': 'Wasserball',
            'description': 'Spiele Wasserball',
            'type': 'spiel',
            'imageName': null,
            'unit': 'Minuten',
            'material': '1 Wasserball',
            'varianten': 'Nur mit links werfen',
          };

          final exercise = Exercise.fromJson(json);

          expect(exercise.material, '1 Wasserball');
          expect(exercise.varianten, 'Nur mit links werfen');
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

    group('Given a JSON map with link', () {
      group('When fromJson is called', () {
        test('Then link is set', () {
          final json = {
            'id': 1,
            'name': 'Test',
            'description': 'desc',
            'type': 'spiel',
            'imageName': null,
            'link': 'spiegel.de',
            'unit': 'Minuten',
          };

          final exercise = Exercise.fromJson(json);

          expect(exercise.link, 'spiegel.de');
        });
      });
    });

    group('Given a JSON map without link field', () {
      group('When fromJson is called', () {
        test('Then link is null', () {
          final json = {
            'id': 1,
            'name': 'Test',
            'description': 'desc',
            'type': 'spiel',
            'imageName': null,
            'unit': 'Minuten',
          };

          final exercise = Exercise.fromJson(json);

          expect(exercise.link, isNull);
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
            material: 'Brett',
            varianten: 'Nur Beine',
          );

          final json = exercise.toJson();

          expect(json['id'], 2);
          expect(json['name'], 'Kraul Beine');
          expect(json['description'], 'Schwimme nur Kraul Beine');
          expect(json['type'], 'technik-kraul');
          expect(json['imageName'], isNull);
          expect(json['link'], isNull);
          expect(json['unit'], 'Meter');
          expect(json['material'], 'Brett');
          expect(json['varianten'], 'Nur Beine');
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
