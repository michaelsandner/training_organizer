import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_entry.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_plan_state.dart';

void main() {
  const exercises = [
    Exercise(
      id: 1,
      name: 'Einschwimmen',
      description: 'Schwimme x meter',
      type: ExerciseType.einschwimmen,
      unit: 'Meter',
    ),
    Exercise(
      id: 2,
      name: 'Kraul Beine',
      description: 'Schwimme nur Kraul Beine',
      type: ExerciseType.technikKraul,
      unit: 'Meter',
    ),
    Exercise(
      id: 3,
      name: 'Wasserball',
      description: 'Spiele Wasserball',
      type: ExerciseType.spiel,
      unit: 'Minuten',
    ),
  ];

  group('ExercisePlanState', () {
    group('Given a state with no entries', () {
      group('When unitSummary is called', () {
        test('Then it returns an empty map', () {
          const state = ExercisePlanState(exercises: exercises, entries: []);

          expect(state.unitSummary, isEmpty);
        });
      });
    });

    group('Given a state with entries of the same unit', () {
      group('When unitSummary is called', () {
        test('Then it returns the sum of distances for that unit', () {
          const state = ExercisePlanState(
            exercises: exercises,
            entries: [
              ExercisePlanEntry(
                type: ExerciseType.einschwimmen,
                selectedExerciseId: 1,
                distance: 100,
              ),
              ExercisePlanEntry(
                type: ExerciseType.technikKraul,
                selectedExerciseId: 2,
                distance: 200,
              ),
            ],
          );

          expect(state.unitSummary, {'Meter': 300});
        });
      });
    });

    group('Given a state with entries of different units', () {
      group('When unitSummary is called', () {
        test('Then it returns the sum for each unit separately', () {
          const state = ExercisePlanState(
            exercises: exercises,
            entries: [
              ExercisePlanEntry(
                type: ExerciseType.einschwimmen,
                selectedExerciseId: 1,
                distance: 100,
              ),
              ExercisePlanEntry(
                type: ExerciseType.spiel,
                selectedExerciseId: 3,
                distance: 15,
              ),
            ],
          );

          expect(state.unitSummary, {'Meter': 100, 'Minuten': 15});
        });
      });
    });
  });
}
