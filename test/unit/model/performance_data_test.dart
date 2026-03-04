import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/performance_data/domain/performance_category.dart';
import 'package:training_organizer/performance_data/domain/performance_data.dart';
import 'package:training_organizer/performance_data/domain/category_position.dart';

void main() {
  group('PerformanceData', () {
    group('Given a valid JSON with nested categories', () {
      final json = {
        'categories': [
          {
            'name': 'Aufgaben der Wasserwacht',
            'children': [
              {
                'name': 'Breitenausbildung',
                'children': [
                  {
                    'name': 'Deutsches Schwimmabzeichen',
                    'children': [
                      {'name': 'DSA-Bronze', 'anzahl': 5},
                      {'name': 'DSA-Silber', 'anzahl': 3},
                    ],
                  },
                ],
              },
            ],
          },
        ],
      };

      group('When fromJson is called', () {
        final data = PerformanceData.fromJson(json);

        test('Then it creates one top-level category', () {
          expect(data.categories.length, 1);
        });

        test('Then the top-level category has the correct name', () {
          expect(data.categories[0].name, 'Aufgaben der Wasserwacht');
        });

        test('Then the deepest elements are leaf elements with anzahl', () {
          final dsa = data.categories[0].children[0].children[0];
          expect(dsa.children[0].isLeaf, isTrue);
          expect(dsa.children[0].anzahl, 5);
          expect(dsa.children[1].isLeaf, isTrue);
          expect(dsa.children[1].anzahl, 3);
        });
      });
    });

    group('Given a PerformanceData with nested categories', () {
      const data = PerformanceData(
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
                      PerformanceCategory(name: 'DSA-Silber', anzahl: 3),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      group('When toJson is called', () {
        final json = data.toJson();

        test('Then it returns a valid JSON map', () {
          expect(json['categories'], isA<List>());
          expect((json['categories'] as List).length, 1);
        });
      });

      group('When updateCount is called with path [0, 0, 0, 1] and value 10',
          () {
        final updated = data.updateCount([0, 0, 0, 1], 10);

        test('Then the DSA-Silber anzahl is updated to 10', () {
          expect(
              updated.categories[0].children[0].children[0].children[1].anzahl,
              10);
        });

        test('Then the DSA-Bronze anzahl is unchanged', () {
          expect(
              updated.categories[0].children[0].children[0].children[0].anzahl,
              5);
        });
      });
    });

    group('Given an empty JSON', () {
      final json = <String, dynamic>{};

      group('When fromJson is called', () {
        final data = PerformanceData.fromJson(json);

        test('Then it creates a PerformanceData with empty categories', () {
          expect(data.categories, isEmpty);
        });
      });
    });

    group('Given PerformanceData.empty()', () {
      group('When created', () {
        final data = PerformanceData.empty();

        test('Then it has no categories', () {
          expect(data.categories, isEmpty);
        });
      });
    });

    group('Given PerformanceData with a leaf that has positionen', () {
      const data = PerformanceData(
        categories: [
          PerformanceCategory(
            name: 'Root',
            children: [
              PerformanceCategory(
                name: 'Leaf',
                anzahl: 5,
                positionen: [
                  CategoryPosition(
                      anzahl: 2, teilnehmende: 'A', beschreibung: 'desc1'),
                  CategoryPosition(
                      anzahl: 3, teilnehmende: 'B', beschreibung: 'desc2'),
                ],
              ),
            ],
          ),
        ],
      );

      group('When updatePosition is called for path [0, 0] index 0', () {
        final updated = data.updatePosition(
          [0, 0],
          0,
          const CategoryPosition(
              anzahl: 10, teilnehmende: 'A', beschreibung: 'updated'),
        );

        test('Then the first position is updated', () {
          final leaf = updated.categories[0].children[0];
          expect(leaf.positionen[0].anzahl, 10);
          expect(leaf.positionen[0].beschreibung, 'updated');
        });

        test('Then the second position is unchanged', () {
          final leaf = updated.categories[0].children[0];
          expect(leaf.positionen[1].anzahl, 3);
        });

        test('Then the leaf anzahl is recalculated from positions', () {
          final leaf = updated.categories[0].children[0];
          expect(leaf.anzahl, 13);
        });
      });
    });

    group('Given PerformanceData with a leaf that has 1 position', () {
      const data = PerformanceData(
        categories: [
          PerformanceCategory(
            name: 'Root',
            children: [
              PerformanceCategory(
                name: 'Leaf',
                anzahl: 5,
                positionen: [
                  CategoryPosition(
                      anzahl: 1, teilnehmende: 'A', beschreibung: 'desc'),
                ],
              ),
            ],
          ),
        ],
      );

      group('When addPosition is called for path [0, 0]', () {
        final updated = data.addPosition([0, 0]);

        test('Then the leaf has 2 positionen', () {
          expect(updated.categories[0].children[0].positionen.length, 2);
        });

        test('Then the new position has default values', () {
          expect(updated.categories[0].children[0].positionen[1],
              const CategoryPosition());
        });
      });

      group('When removePosition is called for path [0, 0] index 0', () {
        final updated = data.removePosition([0, 0], 0);

        test('Then the leaf has 0 positionen', () {
          expect(updated.categories[0].children[0].positionen.length, 0);
        });
      });
    });
  });
}
