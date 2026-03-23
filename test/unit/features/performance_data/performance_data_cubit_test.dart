import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/data/performance_data_file_handler.dart';
import 'package:training_organizer/model/qualifications.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/rs_bronze.dart';
import 'package:training_organizer/model/qualifications/rs_gold.dart';
import 'package:training_organizer/model/qualifications/rs_silber.dart';
import 'package:training_organizer/model/qualifications/silber.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/domain/badge_import_result.dart';
import 'package:training_organizer/domain/category_position.dart';
import 'package:training_organizer/domain/performance_category.dart';
import 'package:training_organizer/domain/performance_data.dart';
import 'package:training_organizer/features/performance_data/performance_data_cubit.dart';
import 'package:training_organizer/features/performance_data/performance_data_state.dart';

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

    group('Given no trainees available', () {
      const performanceData = PerformanceData(
        categories: [
          PerformanceCategory(
            name: 'Breitenausbildung',
            children: [
              PerformanceCategory(name: 'DSA-Bronze'),
            ],
          ),
        ],
      );

      group('When importBadges is called with empty list', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then an error message is emitted',
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: performanceData,
          ),
          act: (cubit) => cubit.importBadges([]),
          expect: () => [
            isA<PerformanceDataState>().having(
              (s) => s.errorMessage,
              'error',
              'Keine Mitgliedsdaten importiert',
            ),
          ],
        );
      });
    });

    group('Given trainees with badges for the selected year', () {
      const performanceData = PerformanceData(
        categories: [
          PerformanceCategory(
            name: 'Breitenausbildung',
            children: [
              PerformanceCategory(name: 'DSA-Bronze'),
              PerformanceCategory(name: 'DSA-Silber'),
              PerformanceCategory(name: 'DSA-Gold'),
              PerformanceCategory(name: 'DRSA-Bronze'),
              PerformanceCategory(name: 'DRSA-Silber'),
              PerformanceCategory(name: 'DRSA-Gold'),
              PerformanceCategory(name: 'sonstige Schwimmabzeichen'),
            ],
          ),
        ],
      );

      final trainees = [
        Trainee(
          surname: 'Müller',
          qualifications: Qualifications(qualifications: [
            Bronze(DateTime(2025, 3, 1)),
            RsBronze(DateTime(2025, 5, 1)),
          ]),
        ),
        Trainee(
          surname: 'Schmidt',
          qualifications: Qualifications(qualifications: [
            Bronze(DateTime(2025, 6, 1)),
            Silber(DateTime(2025, 7, 1)),
            RsSilber(DateTime(2025, 8, 1)),
          ]),
        ),
        Trainee(
          surname: 'Fischer',
          qualifications: Qualifications(qualifications: [
            Gold(DateTime(2025, 4, 1)),
            RsGold(DateTime(2025, 9, 1)),
            Pirat(DateTime(2025, 2, 1)),
          ]),
        ),
      ];

      group('When importBadges is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then a badgeImportResult with correct entries is emitted',
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: performanceData,
            selectedYear: 2025,
          ),
          act: (cubit) => cubit.importBadges(trainees),
          expect: () => [
            isA<PerformanceDataState>().having(
              (s) => s.badgeImportResult,
              'badgeImportResult',
              isA<BadgeImportResult>()
                  .having((r) => r.entries.length, 'entries count', 7)
                  .having(
                    (r) => r.entries
                        .firstWhere(
                            (e) => e.targetCategoryName == 'DRSA-Bronze')
                        .count,
                    'DRSA-Bronze',
                    1,
                  )
                  .having(
                    (r) => r.entries
                        .firstWhere((e) => e.targetCategoryName == 'DSA-Bronze')
                        .count,
                    'DSA-Bronze',
                    2,
                  )
                  .having(
                    (r) => r.entries
                        .firstWhere((e) =>
                            e.targetCategoryName == 'sonstige Schwimmabzeichen')
                        .beschreibung,
                    'Pirat beschreibung',
                    'Pirat',
                  ),
            ),
          ],
        );
      });

      group('When applyBadgeImport is called after importBadges', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then badge counts are added as positions to matching categories',
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: performanceData,
            selectedYear: 2025,
          ),
          act: (cubit) {
            cubit.importBadges(trainees);
            cubit.applyBadgeImport();
          },
          expect: () => [
            // First emission: badgeImportResult is set
            isA<PerformanceDataState>().having(
              (s) => s.badgeImportResult,
              'badgeImportResult',
              isNotNull,
            ),
            // Second emission: positions applied, result cleared
            isA<PerformanceDataState>()
                .having(
                  (s) => s.badgeImportResult,
                  'badgeImportResult cleared',
                  isNull,
                )
                .having(
                  (s) => s.performanceData!.categories[0].children
                      .firstWhere((c) => c.name == 'DSA-Bronze')
                      .positionen
                      .first
                      .anzahl,
                  'DSA-Bronze count',
                  2,
                )
                .having(
                  (s) => s.performanceData!.categories[0].children
                      .firstWhere((c) => c.name == 'DSA-Silber')
                      .positionen
                      .first
                      .anzahl,
                  'DSA-Silber count',
                  1,
                )
                .having(
                  (s) => s.performanceData!.categories[0].children
                      .firstWhere((c) => c.name == 'DSA-Gold')
                      .positionen
                      .first
                      .anzahl,
                  'DSA-Gold count',
                  1,
                )
                .having(
                  (s) => s.performanceData!.categories[0].children
                      .firstWhere((c) => c.name == 'DRSA-Bronze')
                      .positionen
                      .first
                      .anzahl,
                  'DRSA-Bronze count',
                  1,
                )
                .having(
                  (s) => s.performanceData!.categories[0].children
                      .firstWhere((c) => c.name == 'DRSA-Silber')
                      .positionen
                      .first
                      .anzahl,
                  'DRSA-Silber count',
                  1,
                )
                .having(
                  (s) => s.performanceData!.categories[0].children
                      .firstWhere((c) => c.name == 'DRSA-Gold')
                      .positionen
                      .first
                      .anzahl,
                  'DRSA-Gold count',
                  1,
                )
                .having(
                  (s) => s.performanceData!.categories[0].children
                      .firstWhere((c) => c.name == 'sonstige Schwimmabzeichen')
                      .positionen
                      .first
                      .anzahl,
                  'sonstige Schwimmabzeichen count',
                  1,
                )
                .having(
                  (s) => s.performanceData!.categories[0].children
                      .firstWhere((c) => c.name == 'sonstige Schwimmabzeichen')
                      .positionen
                      .first
                      .beschreibung,
                  'sonstige Schwimmabzeichen beschreibung',
                  'intern',
                ),
          ],
        );
      });
    });

    group('Given trainees with badges from a different year', () {
      const performanceData = PerformanceData(
        categories: [
          PerformanceCategory(
            name: 'Breitenausbildung',
            children: [
              PerformanceCategory(name: 'DSA-Bronze'),
            ],
          ),
        ],
      );

      final trainees = [
        Trainee(
          surname: 'Müller',
          qualifications: Qualifications(qualifications: [
            Bronze(DateTime(2024, 3, 1)),
          ]),
        ),
      ];

      group('When importBadges is called for year 2025', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then a badgeImportResult with empty entries is emitted',
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: performanceData,
            selectedYear: 2025,
          ),
          act: (cubit) => cubit.importBadges(trainees),
          expect: () => [
            isA<PerformanceDataState>().having(
              (s) => s.badgeImportResult?.entries,
              'entries',
              isEmpty,
            ),
          ],
        );
      });
    });

    group('Given no performance data loaded', () {
      final trainees = [
        Trainee(
          surname: 'Müller',
          qualifications: Qualifications(qualifications: [
            Bronze(DateTime(2025, 3, 1)),
          ]),
        ),
      ];

      group('When importBadges is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then nothing happens',
          build: () => PerformanceDataCubit(mockFileHandler),
          act: (cubit) => cubit.importBadges(trainees),
          expect: () => [],
        );
      });
    });

    group('Given a pending badge import result', () {
      group('When dismissBadgeImport is called', () {
        blocTest<PerformanceDataCubit, PerformanceDataState>(
          'Then the badge import result is cleared',
          build: () => PerformanceDataCubit(mockFileHandler),
          seed: () => PerformanceDataState.initial().copyWith(
            performanceData: const PerformanceData(categories: []),
            badgeImportResult: const BadgeImportResult(entries: [
              BadgeImportEntry(targetCategoryName: 'DSA-Bronze', count: 1),
            ]),
          ),
          act: (cubit) => cubit.dismissBadgeImport(),
          expect: () => [
            isA<PerformanceDataState>().having(
              (s) => s.badgeImportResult,
              'badgeImportResult',
              isNull,
            ),
          ],
        );
      });
    });
  });
}
