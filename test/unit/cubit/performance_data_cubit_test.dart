import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/data/performance_data_file_handler.dart';
import 'package:training_organizer/performance_data/domain/performance_category.dart';
import 'package:training_organizer/performance_data/domain/performance_data.dart';
import 'package:training_organizer/performance_data/domain/category_position.dart';
import 'package:training_organizer/performance_data/ui/performance_data_cubit.dart';
import 'package:training_organizer/performance_data/ui/performance_data_state.dart';

class MockPerformanceDataFileHandler extends Mock
    implements PerformanceDataFileHandler {}

void main() {
  late MockPerformanceDataFileHandler mockFileHandler;

  setUp(() {
    mockFileHandler = MockPerformanceDataFileHandler();
  });

  group('PerformanceDataCubit', () {
    group('Given the cubit is created', () {
      group('When no action is performed', () {
        test('Then the initial state has no data and no spinner', () {
          final cubit = PerformanceDataCubit(mockFileHandler);
          expect(cubit.state.performanceData, isNull);
          expect(cubit.state.showLoadingSpinner, isFalse);
          expect(cubit.state.errorMessage, isNull);
          expect(cubit.state.exportState, PerformanceDataExportState.none);
          cubit.close();
        });
      });
    });

    group('Given a successful import', () {
      const testData = PerformanceData(
        categories: [
          PerformanceCategory(
            name: 'Aufgaben der Wasserwacht',
            children: [
              PerformanceCategory(
                name: 'Breitenausbildung',
                children: [
                  PerformanceCategory(
                    name: 'Deutsches Schwimmabzeichen',
                    children: [
                      PerformanceCategory(name: 'DSA-Bronze', anzahl: 5),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      group('When importData is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then data is loaded and spinner is hidden',
          setUp: () {
            when(() => mockFileHandler.importPerformanceData())
                .thenAnswer((_) async => testData);
          },
          build: () => PerformanceDataCubit(mockFileHandler),
          act: (cubit) => cubit.importData(),
          expect: () => [
            PerformanceDataState.initial().copyWith(showLoadingSpinner: true),
            PerformanceDataState.initial().copyWith(
              performanceData: testData,
              showLoadingSpinner: false,
            ),
          ],
        );
      });
    });

    group('Given the import throws an exception', () {
      group('When importData is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then an error message is emitted',
          setUp: () {
            when(() => mockFileHandler.importPerformanceData())
                .thenThrow(Exception('Datei nicht lesbar'));
          },
          build: () => PerformanceDataCubit(mockFileHandler),
          act: (cubit) => cubit.importData(),
          expect: () => [
            PerformanceDataState.initial().copyWith(showLoadingSpinner: true),
            isA<PerformanceDataState>()
                .having((s) => s.showLoadingSpinner, 'spinner', false)
                .having((s) => s.errorMessage, 'error', isNotNull),
          ],
        );
      });
    });

    group('Given loaded performance data', () {
      const initialData = PerformanceData(
        categories: [
          PerformanceCategory(
            name: 'Test',
            children: [
              PerformanceCategory(name: 'Kind', anzahl: 2),
            ],
          ),
        ],
      );

      group('When updateCount is called with path [0, 0] and value 10', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then the count is updated',
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: initialData,
          ),
          act: (cubit) => cubit.updateCount([0, 0], 10),
          expect: () => [
            isA<PerformanceDataState>().having(
              (s) => s.performanceData!.categories[0].children[0].anzahl,
              'updated anzahl',
              10,
            ),
          ],
        );
      });
    });

    group('Given loaded data and a successful export', () {
      const testData = PerformanceData(
        categories: [
          PerformanceCategory(name: 'Test', anzahl: 1),
        ],
      );

      group('When exportData is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then export is successful',
          setUp: () {
            when(() => mockFileHandler.exportPerformanceData(testData))
                .thenAnswer((_) async {});
          },
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: testData,
          ),
          act: (cubit) => cubit.exportData(),
          expect: () => [
            isA<PerformanceDataState>().having((s) => s.exportState, 'export',
                PerformanceDataExportState.exportSuccessful),
            isA<PerformanceDataState>().having((s) => s.exportState, 'export',
                PerformanceDataExportState.none),
          ],
        );
      });
    });

    group('Given loaded data and the export throws an exception', () {
      const testData = PerformanceData(
        categories: [
          PerformanceCategory(name: 'Test', anzahl: 1),
        ],
      );

      group('When exportData is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then an error is emitted',
          setUp: () {
            when(() => mockFileHandler.exportPerformanceData(testData))
                .thenThrow(Exception('Schreibfehler'));
          },
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: testData,
          ),
          act: (cubit) => cubit.exportData(),
          expect: () => [
            isA<PerformanceDataState>()
                .having((s) => s.exportState, 'export',
                    PerformanceDataExportState.exportFailed)
                .having((s) => s.errorMessage, 'error', isNotNull),
            isA<PerformanceDataState>().having((s) => s.exportState, 'export',
                PerformanceDataExportState.none),
          ],
        );
      });
    });

    group('Given loaded data with positionen', () {
      const initialData = PerformanceData(
        categories: [
          PerformanceCategory(
            name: 'Root',
            children: [
              PerformanceCategory(
                name: 'Leaf',
                anzahl: 5,
                positionen: [
                  CategoryPosition(
                      anzahl: 1, teilnehmende: 'A', beschreibung: 'x'),
                  CategoryPosition(
                      anzahl: 2, teilnehmende: 'B', beschreibung: 'y'),
                ],
              ),
            ],
          ),
        ],
      );

      group('When updatePosition is called for index 0', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then the position is updated',
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: initialData,
          ),
          act: (cubit) => cubit.updatePosition(
            [0, 0],
            0,
            const CategoryPosition(
                anzahl: 99, teilnehmende: 'A', beschreibung: 'new'),
          ),
          expect: () => [
            isA<PerformanceDataState>().having(
              (s) => s.performanceData!.categories[0].children[0].positionen[0]
                  .anzahl,
              'updated position anzahl',
              99,
            ),
          ],
        );
      });
    });

    group('Given loaded data with 1 position', () {
      const initialData = PerformanceData(
        categories: [
          PerformanceCategory(
            name: 'Root',
            children: [
              PerformanceCategory(
                name: 'Leaf',
                anzahl: 5,
                positionen: [
                  CategoryPosition(
                      anzahl: 1, teilnehmende: 'A', beschreibung: 'x'),
                ],
              ),
            ],
          ),
        ],
      );

      group('When addPosition is called for path [0, 0]', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then a new empty position is added',
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: initialData,
          ),
          act: (cubit) => cubit.addPosition([0, 0]),
          expect: () => [
            isA<PerformanceDataState>().having(
              (s) => s
                  .performanceData!.categories[0].children[0].positionen.length,
              'positionen count',
              2,
            ),
          ],
        );
      });

      group('When removePosition is called for path [0, 0] index 0', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then the position is removed',
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: initialData,
          ),
          act: (cubit) => cubit.removePosition([0, 0], 0),
          expect: () => [
            isA<PerformanceDataState>().having(
              (s) => s
                  .performanceData!.categories[0].children[0].positionen.length,
              'positionen count',
              0,
            ),
          ],
        );
      });
    });
  });
}
