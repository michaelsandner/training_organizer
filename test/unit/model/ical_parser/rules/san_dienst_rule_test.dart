import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/san_dienst_rule.dart';

void main() {
  late SanDienstRule sut;

  setUp(() {
    sut = SanDienstRule();
  });

  group('SanDienstRule', () {
    group('Given a summary "San-Dienst Post"', () {
      test('Then matches returns true (contains match)', () {
        expect(sut.matches('San-Dienst Post'), isTrue);
      });
    });

    group('Given a summary "San-Dienst"', () {
      test('Then matches returns true', () {
        expect(sut.matches('San-Dienst'), isTrue);
      });
    });

    group('Given a summary "Dienstabend"', () {
      test('Then matches returns false', () {
        expect(sut.matches('Dienstabend'), isFalse);
      });
    });

    group('Given an event with 2 Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then eventCount is 1 and teilnehmendeCount is 2', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 1, 8, 0),
            description: 'Teilnehmende: Uwe, Andi',
          );

          expect(sut.eventCount, 1);
          expect(sut.teilnehmendeCount, 2);
        });
      });
    });

    group('Given an event without description', () {
      group('When processEvent is called', () {
        test('Then eventCount is 1 and teilnehmendeCount is 1', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 1, 8, 0),
          );

          expect(sut.eventCount, 1);
          expect(sut.teilnehmendeCount, 1);
        });
      });
    });

    group('Given two events processed', () {
      group('When applyEntries is accessed', () {
        test('Then Anzahl uses eventCount and Stunden uses teilnehmendeCount',
            () {
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 1, 8, 0),
            description: 'Teilnehmende: Uwe, Andi',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 15, 8, 0),
          );

          expect(sut.applyEntries, hasLength(2));
          expect(sut.applyEntries[0].targetCategoryName,
              SanDienstRule.targetCategoryAnzahl);
          expect(sut.applyEntries[0].value, 2);
          expect(sut.applyEntries[1].targetCategoryName,
              SanDienstRule.targetCategoryStunden);
          expect(sut.applyEntries[1].value, 3);
        });
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then all counters are 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 1, 8, 0),
            description: 'Teilnehmende: Uwe',
          );

          sut.reset();

          expect(sut.eventCount, 0);
          expect(sut.teilnehmendeCount, 0);
        });
      });
    });
  });
}
