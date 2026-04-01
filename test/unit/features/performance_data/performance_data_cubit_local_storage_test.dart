import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/data/performance_data_file_handler.dart';
import 'package:training_organizer/domain/performance_data/category_position.dart';
import 'package:training_organizer/domain/performance_data/performance_category.dart';
import 'package:training_organizer/domain/performance_data/performance_data.dart';
import 'package:training_organizer/features/performance_data/performance_data_cubit.dart';
import 'package:training_organizer/features/performance_data/performance_data_state.dart';
import 'package:training_organizer/data/local_storage_repository.dart';

class MockPerformanceDataFileHandler extends Mock
    implements PerformanceDataFileHandler {}

class MockLocalStorageRepository extends Mock
    implements LocalStorageRepository {}

class FakePerformanceData extends Fake implements PerformanceData {}

void main() {
  late MockPerformanceDataFileHandler mockFileHandler;
  late MockLocalStorageRepository mockLocalStorage;

  const testData = PerformanceData(
    categories: [
      PerformanceCategory(
        name: 'Kategorie A',
        children: [
          PerformanceCategory(name: 'Unterkategorie', anzahl: 3),
        ],
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(FakePerformanceData());
  });

  setUp(() {
    mockFileHandler = MockPerformanceDataFileHandler();
    mockLocalStorage = MockLocalStorageRepository();

    when(() => mockLocalStorage.loadPerformanceData())
        .thenAnswer((_) async => null);
    when(() => mockLocalStorage.savePerformanceData(any()))
        .thenAnswer((_) async {});
    when(() => mockLocalStorage.loadTrainees())
        .thenAnswer((_) async => null);
    when(() => mockLocalStorage.saveTrainees(any()))
        .thenAnswer((_) async {});
  });

  group('PerformanceDataCubit with LocalStorage', () {
    group('Given local storage has saved performance data', () {
      setUp(() {
        when(() => mockLocalStorage.loadPerformanceData())
            .thenAnswer((_) async => testData);
      });

      group('When init is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then performance data is loaded from local storage',
          build: () => PerformanceDataCubit(
            mockFileHandler,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.init(),
          expect: () => [
            PerformanceDataState.initial().copyWith(performanceData: testData),
          ],
        );
      });
    });

    group('Given local storage is empty', () {
      group('When init is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then no state change occurs',
          build: () => PerformanceDataCubit(
            mockFileHandler,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.init(),
          expect: () => [],
        );
      });
    });

    group('Given a cubit with local storage', () {
      group('When importData is called successfully', () {
        setUp(() {
          when(() => mockFileHandler.importPerformanceData())
              .thenAnswer((_) async => testData);
        });

        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then performance data is saved to local storage',
          build: () => PerformanceDataCubit(
            mockFileHandler,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.importData(),
          verify: (_) {
            verify(() => mockLocalStorage.savePerformanceData(testData))
                .called(1);
          },
        );
      });

      group('When updateCount is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then updated data is saved to local storage',
          seed: () =>
              PerformanceDataState.initial().copyWith(performanceData: testData),
          build: () => PerformanceDataCubit(
            mockFileHandler,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.updateCount([0, 0], 5),
          verify: (_) {
            verify(() => mockLocalStorage.savePerformanceData(any())).called(1);
          },
        );
      });

      group('When addPosition is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then updated data is saved to local storage',
          seed: () =>
              PerformanceDataState.initial().copyWith(performanceData: testData),
          build: () => PerformanceDataCubit(
            mockFileHandler,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.addPosition([0, 0]),
          verify: (_) {
            verify(() => mockLocalStorage.savePerformanceData(any())).called(1);
          },
        );
      });

      group('When removePosition is called', () {
        const dataWithPosition = PerformanceData(
          categories: [
            PerformanceCategory(
              name: 'Kategorie A',
              children: [
                PerformanceCategory(
                  name: 'Unterkategorie',
                  positionen: [
                    CategoryPosition(anzahl: 2, beschreibung: 'Test'),
                  ],
                ),
              ],
            ),
          ],
        );

        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then updated data is saved to local storage',
          seed: () => PerformanceDataState.initial()
              .copyWith(performanceData: dataWithPosition),
          build: () => PerformanceDataCubit(
            mockFileHandler,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.removePosition([0, 0], 0),
          verify: (_) {
            verify(() => mockLocalStorage.savePerformanceData(any())).called(1);
          },
        );
      });

      group('When updatePosition is called', () {
        const dataWithPosition = PerformanceData(
          categories: [
            PerformanceCategory(
              name: 'Kategorie A',
              children: [
                PerformanceCategory(
                  name: 'Unterkategorie',
                  positionen: [
                    CategoryPosition(anzahl: 2, beschreibung: 'Test'),
                  ],
                ),
              ],
            ),
          ],
        );

        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then updated data is saved to local storage',
          seed: () => PerformanceDataState.initial()
              .copyWith(performanceData: dataWithPosition),
          build: () => PerformanceDataCubit(
            mockFileHandler,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.updatePosition(
            [0, 0],
            0,
            const CategoryPosition(anzahl: 10, beschreibung: 'Updated'),
          ),
          verify: (_) {
            verify(() => mockLocalStorage.savePerformanceData(any())).called(1);
          },
        );
      });
    });

    group('Given no local storage repository', () {
      group('When importData is called', () {
        setUp(() {
          when(() => mockFileHandler.importPerformanceData())
              .thenAnswer((_) async => testData);
        });

        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then no save is attempted',
          build: () => PerformanceDataCubit(mockFileHandler),
          act: (cubit) => cubit.importData(),
          verify: (_) {
            verifyNever(
                () => mockLocalStorage.savePerformanceData(any()));
          },
        );
      });
    });

    group('Given local storage has cached performance data', () {
      const cachedData = PerformanceData(
        categories: [
          PerformanceCategory(name: 'Cached Category', anzahl: 99),
        ],
      );

      setUp(() {
        when(() => mockLocalStorage.loadPerformanceData())
            .thenAnswer((_) async => cachedData);
      });

      group('When importData is called with a new file', () {
        setUp(() {
          when(() => mockFileHandler.importPerformanceData())
              .thenAnswer((_) async => testData);
        });

        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then only the newly imported data is used and cached state is overwritten',
          build: () => PerformanceDataCubit(
            mockFileHandler,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.importData(),
          expect: () => [
            PerformanceDataState.initial().copyWith(showLoadingSpinner: true),
            predicate<PerformanceDataState>((s) =>
                s.performanceData == testData &&
                s.performanceData != cachedData &&
                !s.showLoadingSpinner),
          ],
          verify: (_) {
            verify(() => mockLocalStorage.savePerformanceData(testData))
                .called(1);
          },
        );
      });
    });
  });
}
