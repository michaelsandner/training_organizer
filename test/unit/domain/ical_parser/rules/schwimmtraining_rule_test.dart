import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/schwimmtraining_rule.dart';

void main() {
  late SchwimmtrainingRule sut;

  setUp(() {
    sut = SchwimmtrainingRule();
  });

  group('SchwimmtrainingRule', () {
    group('Given a description with "Tag:Schwimmtraining"', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Schwimmtraining', description: 'Tag:Schwimmtraining'),
            isTrue);
      });
    });

    group('Given a description with "tag: schwimmtraining" (lowercase)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Training', description: 'tag: schwimmtraining'),
            isTrue);
      });
    });

    group('Given a description with "TAG:SCHWIMMTRAINING" (uppercase)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Training', description: 'TAG:SCHWIMMTRAINING'),
            isTrue);
      });
    });

    group('Given a description with "TaG: SchWimmTraining" (mixed case)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Training', description: 'TaG: SchWimmTraining'),
            isTrue);
      });
    });

    group('Given no description', () {
      test('Then matches returns false', () {
        expect(sut.matches(summary: 'Schwimmtraining'), isFalse);
      });
    });

    group('Given two events with Teilnehmende:5 and 2h/1.5h duration', () {
      group('When processEvent is called for each', () {
        test('Then eventCount is 2 and totalStunden is 18', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
            description: 'Tag:Schwimmtraining\nTeilnehmende:5',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 14, 18, 0),
            endDateTime: DateTime(2026, 1, 14, 19, 30),
            description: 'Tag:Schwimmtraining\nTeilnehmende:5',
          );

          // 2h*5 + 2h*5 = 20 (1.5h rounds up to 2h)
          expect(sut.eventCount, 2);
          expect(sut.totalStunden, 20);
        });
      });
    });

    group('Given an event without Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then eventCount is 1 and participants fallback to 1', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
            description: 'Tag:Schwimmtraining',
          );

          expect(sut.eventCount, 1);
          // 2h * 1 participant = 2
          expect(sut.totalStunden, 2);
        });
      });
    });

    group('Given events were processed', () {
      group('When displayRows is accessed', () {
        test(
            'Then Anzahl shows event count and Stunden shows hours*participants',
            () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
            description: 'Tag:Schwimmtraining\nTeilnehmende:3',
          );

          expect(sut.displayRows, hasLength(2));
          expect(
              sut.displayRows[0].label, SchwimmtrainingRule.displayLabelAnzahl);
          expect(sut.displayRows[0].value, 1);
          expect(sut.displayRows[1].label,
              SchwimmtrainingRule.displayLabelStunden);
          // 2h * 3 participants = 6
          expect(sut.displayRows[1].value, 6);
        });
      });
    });

    group('Given events were processed', () {
      group('When applyEntries is accessed', () {
        test('Then Anzahl and Stunden are each a single summarized entry', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
            description: 'Tag:Schwimmtraining\nTeilnehmende:3',
            summary: 'Schwimmtraining',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 14, 18, 0),
            endDateTime: DateTime(2026, 1, 14, 19, 30),
            description: 'Tag:Schwimmtraining\nTeilnehmende:5',
            summary: 'Schwimmtraining',
          );

          // 1 Anzahl entry + 1 summarized Stunden entry
          expect(sut.applyEntries, hasLength(2));
          expect(sut.applyEntries[0].targetCategoryName,
              SchwimmtrainingRule.targetCategoryAnzahl);
          expect(sut.applyEntries[0].value, 2); // eventCount
          expect(sut.applyEntries[0].beschreibung, 'Jugendtraining (iCal)');
          expect(sut.applyEntries[1].targetCategoryName,
              SchwimmtrainingRule.targetCategoryStunden);
          // 2h*3 + 2h*5 = 16
          expect(sut.applyEntries[1].value, 16);
          expect(sut.applyEntries[1].beschreibung, 'Jugendtraining (iCal)');
        });
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then all counters are 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
            description: 'Tag:Schwimmtraining\nTeilnehmende:3',
          );

          sut.reset();

          expect(sut.eventCount, 0);
          expect(sut.totalStunden, 0);
        });
      });
    });
  });
}
