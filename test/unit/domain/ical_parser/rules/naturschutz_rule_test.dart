import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/naturschutz_rule.dart';

void main() {
  late NaturschutzRule sut;

  setUp(() {
    sut = NaturschutzRule();
  });

  group('NaturschutzRule', () {
    group('Given a summary "Biotoppflege (Naturschutz)"', () {
      test('Then matches returns true', () {
        expect(sut.matches('Biotoppflege (Naturschutz)'), isTrue);
      });
    });

    group('Given a summary "Naturschutz"', () {
      test('Then matches returns false (needs parentheses)', () {
        expect(sut.matches('Naturschutz'), isFalse);
      });
    });

    group('Given an event with 2 Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 2', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            description: 'Teilnehmende: Max, Erika',
            summary: 'Biotoppflege (Naturschutz)',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 2);
          expect(sut.applyEntries[0].teilnehmende, '2');
          expect(sut.applyEntries[0].beschreibung,
              'Biotoppflege (Naturschutz) (iCal)');
        });
      });
    });

    group('Given an event without description', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 1', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            summary: 'Gewässerreinigung (Naturschutz)',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 1);
          expect(sut.applyEntries[0].teilnehmende, '');
        });
      });
    });

    group('Given multiple events', () {
      group('When processEvent is called for each', () {
        test('Then each event creates a separate entry', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            description: 'Teilnehmende: Max, Erika',
            summary: 'Biotoppflege (Naturschutz)',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 15, 9, 0),
            summary: 'Gewässerreinigung (Naturschutz)',
          );

          expect(sut.applyEntries, hasLength(2));
          expect(sut.applyEntries[0].beschreibung,
              'Biotoppflege (Naturschutz) (iCal)');
          expect(sut.applyEntries[1].beschreibung,
              'Gewässerreinigung (Naturschutz) (iCal)');
        });

        test('Then displayRows shows the total', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            description: 'Teilnehmende: Max, Erika',
            summary: 'Biotoppflege (Naturschutz)',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 15, 9, 0),
            summary: 'Gewässerreinigung (Naturschutz)',
          );

          expect(sut.displayRows, hasLength(1));
          expect(sut.displayRows[0].value, 3);
        });
      });
    });

    group('Given the targetCategoryName', () {
      test('Then it is Naturschutz', () {
        expect(sut.targetCategoryName, 'Naturschutz');
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then applyEntries is empty', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            summary: 'Test (Naturschutz)',
          );

          sut.reset();

          expect(sut.applyEntries, isEmpty);
          expect(sut.displayRows.first.value, 0);
        });
      });
    });
  });
}
