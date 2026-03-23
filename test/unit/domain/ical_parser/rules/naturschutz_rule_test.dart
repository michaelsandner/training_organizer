import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/naturschutz_rule.dart';

void main() {
  late NaturschutzRule sut;

  setUp(() {
    sut = NaturschutzRule();
  });

  group('NaturschutzRule', () {
    group('Given a description with "Tag:Naturschutz"', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Biotoppflege', description: 'Tag:Naturschutz'),
            isTrue);
      });
    });

    group('Given a description with "tag: naturschutz" (lowercase)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Biotoppflege', description: 'tag: naturschutz'),
            isTrue);
      });
    });

    group('Given no description', () {
      test('Then matches returns false', () {
        expect(sut.matches(summary: 'Naturschutz'), isFalse);
      });
    });

    group('Given an event with Teilnehmende:2 and 3 hours', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 6 (3h × 2)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            endDateTime: DateTime(2026, 4, 10, 12, 0),
            description: 'Tag:Naturschutz\nTeilnehmende:2',
            summary: 'Biotoppflege',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 6);
          expect(sut.applyEntries[0].teilnehmende, '2');
          expect(sut.applyEntries[0].beschreibung,
              'Biotoppflege 10.04.2026 (iCal)');
        });
      });
    });

    group('Given an event without Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then value uses 1 as participant count', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            endDateTime: DateTime(2026, 4, 10, 12, 0),
            description: 'Tag:Naturschutz',
            summary: 'Gewässerreinigung',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 3);
          expect(sut.applyEntries[0].teilnehmende, '');
        });
      });
    });

    group('Given multiple events', () {
      group('When processEvent is called for each', () {
        test('Then each event creates a separate entry with date', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            endDateTime: DateTime(2026, 4, 10, 12, 0),
            description: 'Tag:Naturschutz\nTeilnehmende:2',
            summary: 'Biotoppflege',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 15, 9, 0),
            endDateTime: DateTime(2026, 5, 15, 11, 0),
            description: 'Tag: Naturschutz',
            summary: 'Gewässerreinigung',
          );

          expect(sut.applyEntries, hasLength(2));
          expect(sut.applyEntries[0].beschreibung,
              'Biotoppflege 10.04.2026 (iCal)');
          expect(sut.applyEntries[1].beschreibung,
              'Gewässerreinigung 15.05.2026 (iCal)');
        });

        test('Then displayRows shows the total', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            endDateTime: DateTime(2026, 4, 10, 12, 0),
            description: 'Tag:Naturschutz\nTeilnehmende:2',
            summary: 'Biotoppflege',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 15, 9, 0),
            endDateTime: DateTime(2026, 5, 15, 11, 0),
            description: 'Tag: Naturschutz',
            summary: 'Gewässerreinigung',
          );

          expect(sut.displayRows, hasLength(1));
          // 3h×2 + 2h×1 = 8
          expect(sut.displayRows[0].value, 8);
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
            endDateTime: DateTime(2026, 4, 10, 12, 0),
            description: 'Tag:Naturschutz',
            summary: 'Test',
          );

          sut.reset();

          expect(sut.applyEntries, isEmpty);
          expect(sut.displayRows.first.value, 0);
        });
      });
    });
  });
}
