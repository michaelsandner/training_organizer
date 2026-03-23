import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/gruppenstunden_rule.dart';

void main() {
  late GruppenstundenRule sut;

  setUp(() {
    sut = GruppenstundenRule();
  });

  group('GruppenstundenRule', () {
    group('Given a description with "Tag:Gruppenstunde"', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Gruppenstunde', description: 'Tag:Gruppenstunde'),
            isTrue);
      });
    });

    group('Given a description with "tag: gruppenstunde" (lowercase)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Gruppenstunde', description: 'tag: gruppenstunde'),
            isTrue);
      });
    });

    group('Given no description', () {
      test('Then matches returns false', () {
        expect(sut.matches(summary: 'Gruppenstunde'), isFalse);
      });
    });

    group('Given two events with Teilnehmende:5 and 2h/3h duration', () {
      group('When processEvent is called for each', () {
        test('Then teilnehmendeTotal is 10 and totalHours is 5', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 2, 7, 14, 0),
            endDateTime: DateTime(2026, 2, 7, 16, 0),
            description: 'Tag:Gruppenstunde\nTeilnehmende:5',
            summary: 'Gruppenstunde',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 7, 14, 0),
            endDateTime: DateTime(2026, 3, 7, 17, 0),
            description: 'Tag:Gruppenstunde\nTeilnehmende:5',
            summary: 'Gruppenstunde',
          );

          expect(sut.teilnehmendeTotal, 10);
          expect(sut.totalHours, 5);
        });
      });
    });

    group('Given events were processed', () {
      group('When displayRows is accessed', () {
        test('Then it contains Anzahl and Stunden rows', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 2, 7, 14, 0),
            endDateTime: DateTime(2026, 2, 7, 16, 0),
            description: 'Tag:Gruppenstunde\nTeilnehmende:3',
            summary: 'Gruppenstunde',
          );

          expect(sut.displayRows, hasLength(2));
          expect(
              sut.displayRows[0].label, GruppenstundenRule.displayLabelAnzahl);
          expect(sut.displayRows[0].value, 3);
          expect(
              sut.displayRows[1].label, GruppenstundenRule.displayLabelStunden);
          expect(sut.displayRows[1].value, 2);
        });
      });
    });

    group('Given events were processed', () {
      group('When applyEntries is accessed', () {
        test('Then per-event Anzahl entries have dates and one Stunden entry',
            () {
          sut.processEvent(
            startDateTime: DateTime(2026, 2, 7, 14, 0),
            endDateTime: DateTime(2026, 2, 7, 16, 0),
            description: 'Tag:Gruppenstunde\nTeilnehmende:3',
            summary: 'Gruppenstunde',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 14, 14, 0),
            endDateTime: DateTime(2026, 3, 14, 17, 0),
            description: 'Tag:Gruppenstunde\nTeilnehmende:5',
            summary: 'Gruppenstunde - Jugend',
          );

          // 2 per-event Anzahl entries + 1 Stunden entry = 3
          expect(sut.applyEntries, hasLength(3));
          expect(sut.applyEntries[0].targetCategoryName,
              GruppenstundenRule.targetCategoryAnzahl);
          expect(sut.applyEntries[0].value, 3);
          expect(sut.applyEntries[0].beschreibung,
              'Gruppenstunde 07.02.2026 (iCal)');
          expect(sut.applyEntries[1].targetCategoryName,
              GruppenstundenRule.targetCategoryAnzahl);
          expect(sut.applyEntries[1].value, 5);
          expect(sut.applyEntries[1].beschreibung,
              'Gruppenstunde - Jugend 14.03.2026 (iCal)');
          expect(sut.applyEntries[2].targetCategoryName,
              GruppenstundenRule.targetCategoryStunden);
          expect(sut.applyEntries[2].value, 5);
        });
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then all counters are 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 2, 7, 14, 0),
            endDateTime: DateTime(2026, 2, 7, 16, 0),
            description: 'Tag:Gruppenstunde\nTeilnehmende:3',
            summary: 'Gruppenstunde',
          );

          sut.reset();

          expect(sut.teilnehmendeTotal, 0);
          expect(sut.totalHours, 0);
        });
      });
    });
  });
}
