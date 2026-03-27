import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_plan_entry.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_type.dart';

void main() {
  group('ExercisePlanEntry', () {
    group('Given an entry with default distance', () {
      group('When created', () {
        test('Then distance is 50', () {
          const entry = ExercisePlanEntry(
            type: ExerciseType.einschwimmen,
            selectedExerciseId: 1,
          );

          expect(entry.distance, 50);
        });
      });
    });

    group('Given a valid JSON map', () {
      group('When fromJson is called', () {
        test('Then an ExercisePlanEntry is created correctly', () {
          final json = {
            'type': 'technik-kraul',
            'selectedExerciseId': 2,
            'distance': 100,
          };

          final entry = ExercisePlanEntry.fromJson(json);

          expect(entry.type, ExerciseType.technikKraul);
          expect(entry.selectedExerciseId, 2);
          expect(entry.distance, 100);
        });
      });
    });

    group('Given an ExercisePlanEntry instance', () {
      group('When toJson is called', () {
        test('Then it returns the correct JSON map', () {
          const entry = ExercisePlanEntry(
            type: ExerciseType.spiel,
            selectedExerciseId: 3,
            distance: 200,
          );

          final json = entry.toJson();

          expect(json['type'], 'spiel');
          expect(json['selectedExerciseId'], 3);
          expect(json['distance'], 200);
        });
      });
    });

    group('Given an ExercisePlanEntry', () {
      group('When copyWith is called with type', () {
        test('Then only type changes', () {
          const entry = ExercisePlanEntry(
            type: ExerciseType.einschwimmen,
            selectedExerciseId: 1,
            distance: 50,
          );

          final updated = entry.copyWith(type: ExerciseType.kraft);

          expect(updated.type, ExerciseType.kraft);
          expect(updated.selectedExerciseId, 1);
          expect(updated.distance, 50);
        });
      });
    });
  });
}
