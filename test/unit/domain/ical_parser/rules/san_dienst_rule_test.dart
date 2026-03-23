import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/san_dienst_rule.dart';

void main() {
  late SanDienstRule sut;

  setUp(() {
    sut = SanDienstRule();
  });

  group('SanDienstRule', () {
    group('Given a description with "Tag:Sandienst"', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'San-Dienst Post', description: 'Tag:Sandienst'),
            isTrue);
      });
    });

    group('Given a description with "tag: sandienst" (lowercase)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(summary: 'San-Dienst', description: 'tag: sandienst'),
            isTrue);
      });
    });

    group('Given no description', () {
      test('Then matches returns false', () {
        expect(sut.matches(summary: 'San-Dienst'), isFalse);
      });
    });

    group('Given an event with Teilnehmende:2 and 9 hours', () {
      group('When processEvent is called', () {
        test('Then eventCount is 1 and totalStunden is 18 (9h × 2)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 1, 8, 0),
            endDateTime: DateTime(2026, 6, 1, 17, 0),
            description: 'Tag:Sandienst\nTeilnehmende:2',
          );

          expect(sut.eventCount, 1);
          expect(sut.totalStunden, 18);
        });
      });
    });

    group('Given an event without Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then eventCount is 1 and totalStunden is hours × 1', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 1, 8, 0),
            endDateTime: DateTime(2026, 6, 1, 17, 0),
            description: 'Tag: Sandienst',
          );

          expect(sut.eventCount, 1);
          expect(sut.totalStunden, 9);
        });
      });
    });

    group('Given two events processed', () {
      group('When applyEntries is accessed', () {
        test(
            'Then Anzahl and Stunden each have per-event entries with title and date',
            () {
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 1, 8, 0),
            endDateTime: DateTime(2026, 6, 1, 17, 0),
            description: 'Tag:Sandienst\nTeilnehmende:2',
            summary: 'San-Dienst Post',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 15, 8, 0),
            endDateTime: DateTime(2026, 6, 15, 12, 0),
            description: 'Tag: Sandienst',
            summary: 'San-Dienst Musical',
          );

          // 2 per-event Anzahl + 2 per-event Stunden = 4
          expect(sut.applyEntries, hasLength(4));

          // Anzahl entries
          expect(sut.applyEntries[0].targetCategoryName,
              SanDienstRule.targetCategoryAnzahl);
          expect(sut.applyEntries[0].value, 1);
          expect(sut.applyEntries[0].beschreibung,
              'San-Dienst Post 01.06.2026 (iCal)');
          expect(sut.applyEntries[1].targetCategoryName,
              SanDienstRule.targetCategoryAnzahl);
          expect(sut.applyEntries[1].value, 1);
          expect(sut.applyEntries[1].beschreibung,
              'San-Dienst Musical 15.06.2026 (iCal)');

          // Stunden entries
          expect(sut.applyEntries[2].targetCategoryName,
              SanDienstRule.targetCategoryStunden);
          // 9h × 2 = 18
          expect(sut.applyEntries[2].value, 18);
          expect(sut.applyEntries[2].beschreibung,
              'San-Dienst Post 01.06.2026 (iCal)');
          expect(sut.applyEntries[3].targetCategoryName,
              SanDienstRule.targetCategoryStunden);
          // 4h × 1 = 4
          expect(sut.applyEntries[3].value, 4);
          expect(sut.applyEntries[3].beschreibung,
              'San-Dienst Musical 15.06.2026 (iCal)');
        });
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then all counters are 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 1, 8, 0),
            endDateTime: DateTime(2026, 6, 1, 17, 0),
            description: 'Tag:Sandienst\nTeilnehmende: 2',
          );

          sut.reset();

          expect(sut.eventCount, 0);
          expect(sut.totalStunden, 0);
        });
      });
    });
  });
}
