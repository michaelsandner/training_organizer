import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/performance_data/domain/performance_category.dart';
import 'package:training_organizer/performance_data/domain/category_position.dart';

void main() {
  group('PerformanceCategory', () {
    group('Given a leaf category JSON with name and anzahl', () {
      final json = {'name': 'DSA-Bronze', 'anzahl': 5};

      group('When fromJson is called', () {
        final category = PerformanceCategory.fromJson(json);

        test('Then it creates a category with the correct name', () {
          expect(category.name, 'DSA-Bronze');
        });

        test('Then it creates a category with the correct anzahl', () {
          expect(category.anzahl, 5);
        });

        test('Then it is a leaf element', () {
          expect(category.isLeaf, isTrue);
        });

        test('Then positionen is empty', () {
          expect(category.positionen, isEmpty);
        });
      });
    });

    group('Given a parent category JSON with children', () {
      final json = {
        'name': 'Deutsches Schwimmabzeichen',
        'children': [
          {'name': 'DSA-Bronze', 'anzahl': 3},
          {'name': 'DSA-Silber', 'anzahl': 7},
        ],
      };

      group('When fromJson is called', () {
        final category = PerformanceCategory.fromJson(json);

        test('Then it creates a category with the correct name', () {
          expect(category.name, 'Deutsches Schwimmabzeichen');
        });

        test('Then it is not a leaf element', () {
          expect(category.isLeaf, isFalse);
        });

        test('Then it has 2 children', () {
          expect(category.children.length, 2);
        });

        test('Then the first child has the correct name', () {
          expect(category.children[0].name, 'DSA-Bronze');
        });

        test('Then the second child has the correct anzahl', () {
          expect(category.children[1].anzahl, 7);
        });
      });
    });

    group('Given a leaf category', () {
      const category = PerformanceCategory(name: 'DSA-Bronze', anzahl: 3);

      group('When toJson is called', () {
        final json = category.toJson();

        test('Then it returns the correct map', () {
          expect(json, {'name': 'DSA-Bronze', 'anzahl': 3});
        });
      });
    });

    group('Given a leaf category with positionen', () {
      const category = PerformanceCategory(
        name: 'DSA-Bronze',
        anzahl: 3,
        positionen: [
          CategoryPosition(
              anzahl: 2, teilnehmende: 'Anna', beschreibung: 'Kurs A'),
        ],
      );

      group('When toJson is called', () {
        final json = category.toJson();

        test('Then it includes positionen', () {
          expect(json['positionen'], isA<List>());
          expect((json['positionen'] as List).length, 1);
          expect((json['positionen'] as List)[0]['teilnehmende'], 'Anna');
        });
      });
    });

    group('Given a leaf JSON with positionen', () {
      final json = {
        'name': 'DSA-Silber',
        'anzahl': 999,
        'positionen': [
          {'anzahl': 1, 'teilnehmende': 'Ben', 'beschreibung': 'Prüfung'},
          {'anzahl': 3, 'teilnehmende': 'Carla', 'beschreibung': 'Übung'},
        ],
      };

      group('When fromJson is called', () {
        final category = PerformanceCategory.fromJson(json);

        test('Then it has 2 positionen', () {
          expect(category.positionen.length, 2);
        });

        test('Then the first position has correct teilnehmende', () {
          expect(category.positionen[0].teilnehmende, 'Ben');
        });

        test('Then anzahl is calculated from positions, not JSON value', () {
          expect(category.anzahl, 4);
        });
      });
    });

    group('Given a leaf category with 2 positionen', () {
      const category = PerformanceCategory(
        name: 'DSA-Bronze',
        anzahl: 5,
        positionen: [
          CategoryPosition(anzahl: 2, teilnehmende: 'A', beschreibung: 'x'),
          CategoryPosition(anzahl: 3, teilnehmende: 'B', beschreibung: 'y'),
        ],
      );

      group('When updatePosition is called for index 1', () {
        final updated = category.updatePosition(
          [],
          1,
          const CategoryPosition(
              anzahl: 10, teilnehmende: 'B', beschreibung: 'z'),
        );

        test('Then the second position is updated', () {
          expect(updated.positionen[1].anzahl, 10);
          expect(updated.positionen[1].beschreibung, 'z');
        });

        test('Then the first position is unchanged', () {
          expect(updated.positionen[0].anzahl, 2);
        });

        test('Then the category anzahl is recalculated', () {
          expect(updated.anzahl, 12);
        });
      });
    });

    group('Given a parent category with children', () {
      const category = PerformanceCategory(
        name: 'Deutsches Schwimmabzeichen',
        children: [
          PerformanceCategory(name: 'DSA-Bronze', anzahl: 3),
          PerformanceCategory(name: 'DSA-Silber', anzahl: 7),
        ],
      );

      group('When toJson is called', () {
        final json = category.toJson();

        test('Then it returns the correct map with children', () {
          expect(json, {
            'name': 'Deutsches Schwimmabzeichen',
            'children': [
              {'name': 'DSA-Bronze', 'anzahl': 3},
              {'name': 'DSA-Silber', 'anzahl': 7},
            ],
          });
        });
      });
    });

    group('Given a leaf category with anzahl 3', () {
      const category = PerformanceCategory(name: 'DSA-Bronze', anzahl: 3);

      group('When updateCount is called with empty path and newCount 10', () {
        final updated = category.updateCount([], 10);

        test('Then the anzahl is updated to 10', () {
          expect(updated.anzahl, 10);
        });

        test('Then the name is unchanged', () {
          expect(updated.name, 'DSA-Bronze');
        });
      });
    });

    group('Given a parent category with a child with anzahl 3', () {
      const category = PerformanceCategory(
        name: 'Deutsches Schwimmabzeichen',
        children: [
          PerformanceCategory(name: 'DSA-Bronze', anzahl: 3),
          PerformanceCategory(name: 'DSA-Silber', anzahl: 7),
        ],
      );

      group('When updateCount is called with path [1] and newCount 15', () {
        final updated = category.updateCount([1], 15);

        test('Then the second child has anzahl 15', () {
          expect(updated.children[1].anzahl, 15);
        });

        test('Then the first child is unchanged', () {
          expect(updated.children[0].anzahl, 3);
        });
      });
    });

    group('Given a leaf category with 1 position', () {
      const category = PerformanceCategory(
        name: 'DSA-Bronze',
        anzahl: 5,
        positionen: [
          CategoryPosition(anzahl: 2, teilnehmende: 'A', beschreibung: 'x'),
        ],
      );

      group('When addPosition is called with empty path', () {
        final updated = category.addPosition([]);

        test('Then a new empty position is appended', () {
          expect(updated.positionen.length, 2);
        });

        test('Then the new position has default values', () {
          expect(updated.positionen[1], const CategoryPosition());
        });

        test('Then the existing position is unchanged', () {
          expect(updated.positionen[0].teilnehmende, 'A');
        });

        test('Then the category anzahl is recalculated', () {
          expect(updated.anzahl, 2);
        });
      });

      group('When removePosition is called for index 0', () {
        final updated = category.removePosition([], 0);

        test('Then the positionen list is empty', () {
          expect(updated.positionen.length, 0);
        });

        test('Then the category anzahl is 0', () {
          expect(updated.anzahl, 0);
        });
      });
    });

    group('Given a parent with a leaf child that has 2 positionen', () {
      const category = PerformanceCategory(
        name: 'Root',
        children: [
          PerformanceCategory(
            name: 'Leaf',
            anzahl: 3,
            positionen: [
              CategoryPosition(anzahl: 1, teilnehmende: 'X', beschreibung: 'a'),
              CategoryPosition(anzahl: 2, teilnehmende: 'Y', beschreibung: 'b'),
            ],
          ),
        ],
      );

      group('When addPosition is called with path [0]', () {
        final updated = category.addPosition([0]);

        test('Then the child has 3 positionen', () {
          expect(updated.children[0].positionen.length, 3);
        });
      });

      group('When removePosition is called with path [0] index 1', () {
        final updated = category.removePosition([0], 1);

        test('Then the child has 1 position', () {
          expect(updated.children[0].positionen.length, 1);
        });

        test('Then the remaining position is the first one', () {
          expect(updated.children[0].positionen[0].teilnehmende, 'X');
        });
      });
    });
  });
}
