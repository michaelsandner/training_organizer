import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/schwimmtraining_rule.dart';

void main() {
  late SchwimmtrainingRule sut;

  setUp(() {
    sut = SchwimmtrainingRule();
  });

  group('SchwimmtrainingRule', () {
    group('Given a summary "Schwimmtraining"', () {
      test('Then matches returns true', () {
        expect(sut.matches('Schwimmtraining'), isTrue);
      });
    });

    group('Given a summary with whitespace "  Schwimmtraining  "', () {
      test('Then matches returns true', () {
        expect(sut.matches('  Schwimmtraining  '), isTrue);
      });
    });

    group('Given a summary "Schwimmtraining Kinder"', () {
      test('Then matches returns false', () {
        expect(sut.matches('Schwimmtraining Kinder'), isFalse);
      });
    });

    group('Given two events with 2h and 1.5h duration', () {
      group('When processEvent is called for each', () {
        test('Then eventCount is 2 and totalHours is 4', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 14, 18, 0),
            endDateTime: DateTime(2026, 1, 14, 19, 30),
          );

          expect(sut.eventCount, 2);
          expect(sut.totalHours, 4);
        });
      });
    });

    group('Given events were processed', () {
      group('When displayRows is accessed', () {
        test('Then it contains Anzahl and Stunden rows', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
          );

          expect(sut.displayRows, hasLength(2));
          expect(
              sut.displayRows[0].label, SchwimmtrainingRule.displayLabelAnzahl);
          expect(sut.displayRows[0].value, 1);
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
          );

          expect(sut.applyEntries, hasLength(2));
          expect(sut.applyEntries[0].targetCategoryName,
              SchwimmtrainingRule.targetCategoryAnzahl);
          expect(sut.applyEntries[1].targetCategoryName,
              SchwimmtrainingRule.targetCategoryStunden);
        });
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then all counters are 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 7, 18, 0),
            endDateTime: DateTime(2026, 1, 7, 20, 0),
          );

          sut.reset();

          expect(sut.eventCount, 0);
          expect(sut.totalHours, 0);
        });
      });
    });
  });
}
