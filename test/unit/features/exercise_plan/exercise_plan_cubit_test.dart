import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/data/local_storage_repository.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_entry.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_repository.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_cubit.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_state.dart';

import 'performance_data_fake.dart';

class MockExerciseRepository extends Mock implements ExerciseRepository {}

class MockLocalStorageRepository extends Mock
    implements LocalStorageRepository {}

void main() {
  late MockExerciseRepository mockExerciseRepository;
  late MockLocalStorageRepository mockLocalStorage;

  const testExercises = [
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

  setUpAll(() {
    registerFallbackValue(<ExercisePlanEntry>[]);
    registerFallbackValue(PerformanceDataFake());
  });

  setUp(() {
    mockExerciseRepository = MockExerciseRepository();
    mockLocalStorage = MockLocalStorageRepository();

    when(() => mockExerciseRepository.loadExercises())
        .thenAnswer((_) async => testExercises);
    when(() => mockLocalStorage.loadExercisePlan())
        .thenAnswer((_) async => null);
    when(() => mockLocalStorage.saveExercisePlan(any()))
        .thenAnswer((_) async {});
    when(() => mockLocalStorage.loadTrainees()).thenAnswer((_) async => null);
    when(() => mockLocalStorage.saveTrainees(any())).thenAnswer((_) async {});
    when(() => mockLocalStorage.loadPerformanceData())
        .thenAnswer((_) async => null);
    when(() => mockLocalStorage.savePerformanceData(any()))
        .thenAnswer((_) async {});
  });

  group('ExercisePlanCubit', () {
    group('Given the cubit is created', () {
      group('When init is called', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then exercises are loaded and default entries are created',
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.init(),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.exercises.length, 'exercises count', 3)
                .having((s) => s.entries.length, 'entries count', 3),
          ],
        );
      });
    });

    group('Given saved exercise plan exists in local storage', () {
      const savedEntries = [
        ExercisePlanEntry(
          type: ExerciseType.technikKraul,
          selectedExerciseId: 2,
          distance: 100,
        ),
      ];

      setUp(() {
        when(() => mockLocalStorage.loadExercisePlan())
            .thenAnswer((_) async => savedEntries);
      });

      group('When init is called', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then saved entries are used instead of defaults',
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.init(),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.exercises.length, 'exercises count', 3)
                .having((s) => s.entries.length, 'entries count', 1)
                .having((s) => s.entries.first.selectedExerciseId,
                    'selected id', 2),
          ],
        );
      });
    });

    group('Given a cubit with loaded exercises', () {
      ExercisePlanState seededState() {
        return const ExercisePlanState(
          exercises: testExercises,
          entries: [
            ExercisePlanEntry(
              type: ExerciseType.einschwimmen,
              selectedExerciseId: 1,
            ),
          ],
        );
      }

      group('When updateEntryType is called', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then the entry type is updated and exercise changes to first of new type',
          seed: seededState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.updateEntryType(0, ExerciseType.technikKraul),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.entries.first.type, 'type',
                    ExerciseType.technikKraul)
                .having((s) => s.entries.first.selectedExerciseId,
                    'selected id', 2),
          ],
        );
      });

      group('When updateEntryExercise is called', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then the selected exercise id is updated',
          seed: seededState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.updateEntryExercise(0, 3),
          expect: () => [
            isA<ExercisePlanState>().having(
                (s) => s.entries.first.selectedExerciseId, 'selected id', 3),
          ],
        );
      });

      group('When updateEntryDistance is called', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then the entry distance is updated',
          seed: seededState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.updateEntryDistance(0, 200),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.entries.first.distance, 'distance', 200),
          ],
        );
      });

      group('When addEntry is called', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then a new entry is added',
          seed: seededState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.addEntry(),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.entries.length, 'entries count', 2),
          ],
        );
      });

      group('When removeEntry is called', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then the entry is removed',
          seed: seededState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.removeEntry(0),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.entries.length, 'entries count', 0),
          ],
        );
      });

      group('When moveEntryUp is called', () {
        ExercisePlanState multiEntryState() {
          return const ExercisePlanState(
            exercises: testExercises,
            entries: [
              ExercisePlanEntry(
                type: ExerciseType.einschwimmen,
                selectedExerciseId: 1,
              ),
              ExercisePlanEntry(
                type: ExerciseType.technikKraul,
                selectedExerciseId: 2,
              ),
              ExercisePlanEntry(
                type: ExerciseType.spiel,
                selectedExerciseId: 3,
              ),
            ],
          );
        }

        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then the entry is moved one position up',
          seed: multiEntryState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.moveEntryUp(1),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.entries.length, 'entries count', 3)
                .having((s) => s.entries[0].selectedExerciseId, 'first id', 2)
                .having((s) => s.entries[1].selectedExerciseId, 'second id', 1),
          ],
        );

        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then nothing happens when the entry is already the first',
          seed: multiEntryState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.moveEntryUp(0),
          expect: () => [],
        );
      });

      group('When moveEntryDown is called', () {
        ExercisePlanState multiEntryState() {
          return const ExercisePlanState(
            exercises: testExercises,
            entries: [
              ExercisePlanEntry(
                type: ExerciseType.einschwimmen,
                selectedExerciseId: 1,
              ),
              ExercisePlanEntry(
                type: ExerciseType.technikKraul,
                selectedExerciseId: 2,
              ),
              ExercisePlanEntry(
                type: ExerciseType.spiel,
                selectedExerciseId: 3,
              ),
            ],
          );
        }

        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then the entry is moved one position down',
          seed: multiEntryState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.moveEntryDown(0),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.entries.length, 'entries count', 3)
                .having((s) => s.entries[0].selectedExerciseId, 'first id', 2)
                .having((s) => s.entries[1].selectedExerciseId, 'second id', 1),
          ],
        );

        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then nothing happens when the entry is already the last',
          seed: multiEntryState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.moveEntryDown(2),
          expect: () => [],
        );
      });

      group('When applyPlanString is called with valid string', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then entries are updated based on the plan string',
          seed: seededState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.applyPlanString('1-3-2'),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.entries.length, 'entries count', 3)
                .having((s) => s.planString, 'plan string', '1-3-2'),
          ],
        );
      });

      group('When applyPlanString is called with invalid format', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then an error message is emitted',
          seed: seededState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.applyPlanString('abc'),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.errorMessage, 'error', isNotNull),
          ],
        );
      });

      group('When applyPlanString is called with unknown exercise id', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then an error message is emitted',
          seed: seededState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.applyPlanString('1-99'),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.errorMessage, 'error', isNotNull),
          ],
        );
      });

      group('When applyPlanString is called with empty string', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then entries are cleared',
          seed: seededState,
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.applyPlanString(''),
          expect: () => [
            isA<ExercisePlanState>()
                .having((s) => s.entries.length, 'entries count', 0),
          ],
        );
      });
    });

    group('Given a cubit with local storage', () {
      group('When addEntry is called', () {
        blocTest<ExercisePlanCubit, ExercisePlanState>(
          'Then entries are saved to local storage',
          seed: () => const ExercisePlanState(
            exercises: testExercises,
            entries: [],
          ),
          build: () => ExercisePlanCubit(
            mockExerciseRepository,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.addEntry(),
          verify: (_) {
            verify(() => mockLocalStorage.saveExercisePlan(any())).called(1);
          },
        );
      });
    });
  });
}
