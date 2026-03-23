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

    group('Given a description with "TAG:GRUPPENSTUNDE" (uppercase)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Gruppenstunde', description: 'TAG:GRUPPENSTUNDE'),
            isTrue);
      });
    });

    group('Given a description with "TaG: GrUppenStunde" (mixed case)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Gruppenstunde', description: 'TaG: GrUppenStunde'),
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
        test('Then eventCount is 2 and totalStunden is 25', () {
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

          // 2h*5 + 3h*5 = 25
          expect(sut.eventCount, 2);
          expect(sut.totalStunden, 25);
        });
      });
    });

    group('Given events were processed', () {
      group('When displayRows is accessed', () {
        test(
            'Then Anzahl shows event count and Stunden shows hours*participants',
            () {
          sut.processEvent(
            startDateTime: DateTime(2026, 2, 7, 14, 0),
            endDateTime: DateTime(2026, 2, 7, 16, 0),
            description: 'Tag:Gruppenstunde\nTeilnehmende:3',
            summary: 'Gruppenstunde',
          );

          expect(sut.displayRows, hasLength(2));
          expect(
              sut.displayRows[0].label, GruppenstundenRule.displayLabelAnzahl);
          expect(sut.displayRows[0].value, 1);
          expect(
              sut.displayRows[1].label, GruppenstundenRule.displayLabelStunden);
          // 2h * 3 participants = 6
          expect(sut.displayRows[1].value, 6);
        });
      });
    });

    group('Given events were processed', () {
      group('When applyEntries is accessed', () {
        test(
            'Then per-event Anzahl entries have value 1 and per-event Stunden entries have hours*participants',
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

          // 2 per-event Anzahl entries + 2 per-event Stunden entries = 4
          expect(sut.applyEntries, hasLength(4));

          // Anzahl entries (value = 1 per event)
          expect(sut.applyEntries[0].targetCategoryName,
              GruppenstundenRule.targetCategoryAnzahl);
          expect(sut.applyEntries[0].value, 1);
          expect(sut.applyEntries[0].beschreibung,
              'Gruppenstunde 07.02.2026 (iCal)');
          expect(sut.applyEntries[1].targetCategoryName,
              GruppenstundenRule.targetCategoryAnzahl);
          expect(sut.applyEntries[1].value, 1);
          expect(sut.applyEntries[1].beschreibung,
              'Gruppenstunde - Jugend 14.03.2026 (iCal)');

          // Stunden entries (hours * participants)
          expect(sut.applyEntries[2].targetCategoryName,
              GruppenstundenRule.targetCategoryStunden);
          // 2h * 3 = 6
          expect(sut.applyEntries[2].value, 6);
          expect(sut.applyEntries[2].beschreibung,
              'Gruppenstunde 07.02.2026 (iCal)');
          expect(sut.applyEntries[3].targetCategoryName,
              GruppenstundenRule.targetCategoryStunden);
          // 3h * 5 = 15
          expect(sut.applyEntries[3].value, 15);
          expect(sut.applyEntries[3].beschreibung,
              'Gruppenstunde - Jugend 14.03.2026 (iCal)');
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

          expect(sut.eventCount, 0);
          expect(sut.totalStunden, 0);
        });
      });
    });
  });
}
