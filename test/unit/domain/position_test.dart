import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/category_position.dart';

void main() {
  group('Position', () {
    group('Given a valid JSON with all fields', () {
      final json = {
        'anzahl': 3,
        'teilnehmende': 'Max Mustermann',
        'beschreibung': 'Anfängerkurs',
      };

      group('When fromJson is called', () {
        final position = CategoryPosition.fromJson(json);

        test('Then anzahl is 3', () {
          expect(position.anzahl, 3);
        });

        test('Then teilnehmende is correct', () {
          expect(position.teilnehmende, 'Max Mustermann');
        });

        test('Then beschreibung is correct', () {
          expect(position.beschreibung, 'Anfängerkurs');
        });
      });
    });

    group('Given an empty JSON', () {
      final json = <String, dynamic>{};

      group('When fromJson is called', () {
        final position = CategoryPosition.fromJson(json);

        test('Then anzahl defaults to 0', () {
          expect(position.anzahl, 0);
        });

        test('Then teilnehmende defaults to empty string', () {
          expect(position.teilnehmende, '');
        });

        test('Then beschreibung defaults to empty string', () {
          expect(position.beschreibung, '');
        });
      });
    });

    group('Given a Position object', () {
      const position = CategoryPosition(
        anzahl: 5,
        teilnehmende: 'Anna',
        beschreibung: 'Fortgeschritten',
      );

      group('When toJson is called', () {
        final json = position.toJson();

        test('Then it returns the correct map', () {
          expect(json, {
            'anzahl': 5,
            'teilnehmende': 'Anna',
            'beschreibung': 'Fortgeschritten',
          });
        });
      });

      group('When copyWith is called with new anzahl', () {
        final updated = position.copyWith(anzahl: 10);

        test('Then anzahl is updated', () {
          expect(updated.anzahl, 10);
        });

        test('Then teilnehmende is unchanged', () {
          expect(updated.teilnehmende, 'Anna');
        });

        test('Then beschreibung is unchanged', () {
          expect(updated.beschreibung, 'Fortgeschritten');
        });
      });

      group('When copyWith is called with new teilnehmende', () {
        final updated = position.copyWith(teilnehmende: 'Ben');

        test('Then teilnehmende is updated', () {
          expect(updated.teilnehmende, 'Ben');
        });

        test('Then anzahl is unchanged', () {
          expect(updated.anzahl, 5);
        });
      });
    });
  });
}
