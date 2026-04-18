import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/data/local_storage_repository.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_collection_repository.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_collection.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_collection_cubit.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_collection_state.dart';

class MockLocalStorageRepository extends Mock
    implements LocalStorageRepository {}

class MockExerciseCollectionRepository extends Mock
    implements ExerciseCollectionRepository {}

void main() {
  late MockLocalStorageRepository mockLocalStorage;
  late MockExerciseCollectionRepository mockFileHandler;

  const testCollections = [
    ExercisePlanCollection(name: 'Plan A', planString: '1-2-3'),
    ExercisePlanCollection(name: 'Plan B', planString: '3-2-1'),
  ];

  setUpAll(() {
    registerFallbackValue(<ExercisePlanCollection>[]);
  });

  setUp(() {
    mockLocalStorage = MockLocalStorageRepository();
    mockFileHandler = MockExerciseCollectionRepository();

    when(() => mockLocalStorage.loadExerciseCollections())
        .thenAnswer((_) async => null);
    when(() => mockLocalStorage.saveExerciseCollections(any()))
        .thenAnswer((_) async {});
  });

  group('ExerciseCollectionCubit', () {
    group('Given the cubit is created', () {
      group('When init is called with no saved collections', () {
        blocTest<ExerciseCollectionCubit, ExerciseCollectionState>(
          'Then state has empty collections',
          build: () => ExerciseCollectionCubit(
            mockLocalStorage,
            mockFileHandler,
          ),
          act: (cubit) => cubit.init(),
          expect: () => [
            isA<ExerciseCollectionState>()
                .having((s) => s.collections, 'collections', isEmpty),
          ],
        );
      });

      group('When init is called with saved collections', () {
        setUp(() {
          when(() => mockLocalStorage.loadExerciseCollections())
              .thenAnswer((_) async => testCollections);
        });

        blocTest<ExerciseCollectionCubit, ExerciseCollectionState>(
          'Then state has the saved collections',
          build: () => ExerciseCollectionCubit(
            mockLocalStorage,
            mockFileHandler,
          ),
          act: (cubit) => cubit.init(),
          expect: () => [
            isA<ExerciseCollectionState>()
                .having(
                    (s) => s.collections.length, 'collections count', 2)
                .having(
                    (s) => s.collections.first.name, 'first name', 'Plan A'),
          ],
        );
      });
    });

    group('Given collections are loaded', () {
      ExerciseCollectionState seededState() {
        return const ExerciseCollectionState(
          collections: testCollections,
        );
      }

      group('When saveCollection is called', () {
        blocTest<ExerciseCollectionCubit, ExerciseCollectionState>(
          'Then the new collection is added',
          seed: seededState,
          build: () => ExerciseCollectionCubit(
            mockLocalStorage,
            mockFileHandler,
          ),
          act: (cubit) => cubit.saveCollection('Plan C', '1-3'),
          expect: () => [
            isA<ExerciseCollectionState>()
                .having(
                    (s) => s.collections.length, 'collections count', 3)
                .having(
                    (s) => s.collections.last.name, 'last name', 'Plan C')
                .having((s) => s.collections.last.planString,
                    'last planString', '1-3'),
          ],
          verify: (_) {
            verify(() => mockLocalStorage.saveExerciseCollections(any()))
                .called(1);
          },
        );
      });

      group('When deleteCollection is called', () {
        blocTest<ExerciseCollectionCubit, ExerciseCollectionState>(
          'Then the collection is removed',
          seed: seededState,
          build: () => ExerciseCollectionCubit(
            mockLocalStorage,
            mockFileHandler,
          ),
          act: (cubit) => cubit.deleteCollection(0),
          expect: () => [
            isA<ExerciseCollectionState>()
                .having(
                    (s) => s.collections.length, 'collections count', 1)
                .having(
                    (s) => s.collections.first.name, 'first name', 'Plan B'),
          ],
          verify: (_) {
            verify(() => mockLocalStorage.saveExerciseCollections(any()))
                .called(1);
          },
        );
      });

      group('When deleteCollection is called with invalid index', () {
        blocTest<ExerciseCollectionCubit, ExerciseCollectionState>(
          'Then nothing happens',
          seed: seededState,
          build: () => ExerciseCollectionCubit(
            mockLocalStorage,
            mockFileHandler,
          ),
          act: (cubit) => cubit.deleteCollection(5),
          expect: () => [],
        );
      });

      group('When exportCollections is called', () {
        setUp(() {
          when(() => mockFileHandler.exportCollections(any(), any()))
              .thenAnswer((_) async {});
        });

        blocTest<ExerciseCollectionCubit, ExerciseCollectionState>(
          'Then collections are exported via file handler',
          seed: seededState,
          build: () => ExerciseCollectionCubit(
            mockLocalStorage,
            mockFileHandler,
          ),
          act: (cubit) => cubit.exportCollections('my_plans'),
          verify: (_) {
            verify(() =>
                    mockFileHandler.exportCollections(testCollections, 'my_plans'))
                .called(1);
          },
        );
      });

      group('When exportCollections fails', () {
        setUp(() {
          when(() => mockFileHandler.exportCollections(any(), any()))
              .thenThrow(Exception('write error'));
        });

        blocTest<ExerciseCollectionCubit, ExerciseCollectionState>(
          'Then an error message is emitted',
          seed: seededState,
          build: () => ExerciseCollectionCubit(
            mockLocalStorage,
            mockFileHandler,
          ),
          act: (cubit) => cubit.exportCollections('my_plans'),
          expect: () => [
            isA<ExerciseCollectionState>()
                .having((s) => s.errorMessage, 'error', isNotNull),
          ],
        );
      });

      group('When importCollections is called successfully', () {
        const importedCollections = [
          ExercisePlanCollection(name: 'Imported', planString: '5-6'),
        ];

        setUp(() {
          when(() => mockFileHandler.importCollections())
              .thenAnswer((_) async => importedCollections);
        });

        blocTest<ExerciseCollectionCubit, ExerciseCollectionState>(
          'Then collections are replaced with imported ones',
          seed: seededState,
          build: () => ExerciseCollectionCubit(
            mockLocalStorage,
            mockFileHandler,
          ),
          act: (cubit) => cubit.importCollections(),
          expect: () => [
            isA<ExerciseCollectionState>()
                .having(
                    (s) => s.collections.length, 'collections count', 1)
                .having((s) => s.collections.first.name, 'first name',
                    'Imported'),
          ],
          verify: (_) {
            verify(() => mockLocalStorage.saveExerciseCollections(any()))
                .called(1);
          },
        );
      });

      group('When importCollections returns null (cancelled)', () {
        setUp(() {
          when(() => mockFileHandler.importCollections())
              .thenAnswer((_) async => null);
        });

        blocTest<ExerciseCollectionCubit, ExerciseCollectionState>(
          'Then state does not change',
          seed: seededState,
          build: () => ExerciseCollectionCubit(
            mockLocalStorage,
            mockFileHandler,
          ),
          act: (cubit) => cubit.importCollections(),
          expect: () => [],
        );
      });

      group('When importCollections fails', () {
        setUp(() {
          when(() => mockFileHandler.importCollections())
              .thenThrow(Exception('read error'));
        });

        blocTest<ExerciseCollectionCubit, ExerciseCollectionState>(
          'Then an error message is emitted',
          seed: seededState,
          build: () => ExerciseCollectionCubit(
            mockLocalStorage,
            mockFileHandler,
          ),
          act: (cubit) => cubit.importCollections(),
          expect: () => [
            isA<ExerciseCollectionState>()
                .having((s) => s.errorMessage, 'error', isNotNull),
          ],
        );
      });
    });
  });
}
