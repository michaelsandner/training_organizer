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
                summary: 'Schwimmtraining',
                description: 'Tag:Schwimmtraining'),
            isTrue);
      });
    });

    group(
        'Given a description with "tag: schwimmtraining" (lowercase)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Training',
                description: 'tag: schwimmtraining'),
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
        test('Then teilnehmendeTotal is 10 and totalHours is 4', () {
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

          expect(sut.teilnehmendeTotal, 10);
          expect(sut.totalHours, 4);
        });
      });
    });

    group('Given an event without Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then teilnehmendeTotal falls back to 1', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
            description: 'Tag:Schwimmtraining',
          );

          expect(sut.teilnehmendeTotal, 1);
        });
      });
    });

    group('Given events were processed', () {
      group('When displayRows is accessed', () {
        test('Then it contains Anzahl and Stunden rows', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
            description: 'Tag:Schwimmtraining\nTeilnehmende:3',
          );

          expect(sut.displayRows, hasLength(2));
          expect(
              sut.displayRows[0].label, SchwimmtrainingRule.displayLabelAnzahl);
          expect(sut.displayRows[0].value, 3);
          expect(sut.displayRows[1].label,
              SchwimmtrainingRule.displayLabelStunden);
          expect(sut.displayRows[1].value, 2);
        });
      });
    });

    group('Given events were processed', () {
      group('When applyEntries is accessed', () {
        test('Then it targets the correct categories', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
            description: 'Tag:Schwimmtraining\nTeilnehmende:3',
          );

          expect(sut.applyEntries, hasLength(2));
          expect(sut.applyEntries[0].targetCategoryName,
              SchwimmtrainingRule.targetCategoryAnzahl);
          expect(sut.applyEntries[0].value, 3);
          expect(sut.applyEntries[1].targetCategoryName,
              SchwimmtrainingRule.targetCategoryStunden);
          expect(sut.applyEntries[1].value, 2);
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

          expect(sut.teilnehmendeTotal, 0);
          expect(sut.totalHours, 0);
        });
      });
    });
  });
}
