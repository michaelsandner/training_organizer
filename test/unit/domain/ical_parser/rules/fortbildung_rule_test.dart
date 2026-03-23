import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/fortbildung_rule.dart';

void main() {
  late FortbildungRule sut;

  setUp(() {
    sut = FortbildungRule();
  });

  group('FortbildungRule', () {
    group('Given a description with "Tag:Fortbildung"', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Erste Hilfe Kurs',
                description: 'Tag:Fortbildung'),
            isTrue);
      });
    });

    group('Given a description with "Tag: Fortbildung" (with space)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Erste Hilfe Kurs',
                description: 'Tag: Fortbildung'),
            isTrue);
      });
    });

    group('Given a description with "tag: fortbildung" (lowercase)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Erste Hilfe Kurs',
                description: 'tag: fortbildung'),
            isTrue);
      });
    });

    group('Given a description without Fortbildung tag', () {
      test('Then matches returns false', () {
        expect(
            sut.matches(
                summary: 'Erste Hilfe Kurs',
                description: 'Some other description'),
            isFalse);
      });
    });

    group('Given no description', () {
      test('Then matches returns false', () {
        expect(sut.matches(summary: 'Fortbildung'), isFalse);
      });
    });

    group('Given an event with Teilnehmende:2 and 2 hours duration', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 4 (2h × 2)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            endDateTime: DateTime(2026, 4, 10, 11, 0),
            description: 'Tag:Fortbildung\nTeilnehmende:2',
            summary: 'Erste Hilfe Kurs',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 4);
          expect(sut.applyEntries[0].teilnehmende, '2');
          expect(sut.applyEntries[0].beschreibung,
              'Erste Hilfe Kurs 10.04.2026 (iCal)');
        });
      });
    });

    group('Given an event without Teilnehmende and 3 hours duration', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 3 (3h × 1)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            endDateTime: DateTime(2026, 4, 10, 12, 0),
            description: 'Tag: Fortbildung',
            summary: 'Sanitätskurs',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 3);
          expect(sut.applyEntries[0].teilnehmende, '');
        });
      });
    });

    group('Given an event without endDateTime', () {
      group('When processEvent is called', () {
        test('Then value falls back to participant count', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            description: 'Tag:Fortbildung\nTeilnehmende: 3',
            summary: 'Sanitätskurs',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 3);
        });
      });
    });

    group('Given multiple events', () {
      group('When processEvent is called for each', () {
        test('Then each event creates a separate entry with date', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            endDateTime: DateTime(2026, 4, 10, 11, 0),
            description: 'Tag:Fortbildung\nTeilnehmende:2',
            summary: 'Erste Hilfe',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 15, 9, 0),
            endDateTime: DateTime(2026, 5, 15, 10, 0),
            description: 'Tag: Fortbildung',
            summary: 'Sanitätskurs',
          );

          expect(sut.applyEntries, hasLength(2));
          expect(sut.applyEntries[0].beschreibung,
              'Erste Hilfe 10.04.2026 (iCal)');
          expect(sut.applyEntries[1].beschreibung,
              'Sanitätskurs 15.05.2026 (iCal)');
        });

        test('Then displayRows shows the total', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            endDateTime: DateTime(2026, 4, 10, 11, 0),
            description: 'Tag:Fortbildung\nTeilnehmende:2',
            summary: 'Erste Hilfe',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 15, 9, 0),
            endDateTime: DateTime(2026, 5, 15, 10, 0),
            description: 'Tag: Fortbildung',
            summary: 'Sanitätskurs',
          );

          expect(sut.displayRows, hasLength(1));
          // 4 (2h×2) + 1 (1h×1) = 5
          expect(sut.displayRows[0].value, 5);
        });
      });
    });

    group('Given the targetCategoryName', () {
      test('Then it is Ausbildung/Fortbildung', () {
        expect(sut.targetCategoryName, 'Ausbildung/Fortbildung');
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then applyEntries is empty', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            endDateTime: DateTime(2026, 4, 10, 11, 0),
            description: 'Tag:Fortbildung',
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
