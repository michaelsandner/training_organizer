import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/dienstabend_rule.dart';

void main() {
  late DienstabendRule sut;

  setUp(() {
    sut = DienstabendRule();
  });

  group('DienstabendRule', () {
    group('Given a summary "Dienstabend"', () {
      test('Then matches returns true', () {
        expect(sut.matches('Dienstabend'), isTrue);
      });
    });

    group('Given a summary with whitespace "  Dienstabend  "', () {
      test('Then matches returns true', () {
        expect(sut.matches('  Dienstabend  '), isTrue);
      });
    });

    group('Given a summary "Dienstabend Fürth"', () {
      test('Then matches returns false', () {
        expect(sut.matches('Dienstabend Fürth'), isFalse);
      });
    });

    group('Given a summary "Dienstabend (abgesagt)"', () {
      test('Then matches returns false', () {
        expect(sut.matches('Dienstabend (abgesagt)'), isFalse);
      });
    });

    group('Given a January event with 3 Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 3', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 21, 18, 30),
            description: 'Teilnehmende: Alex, Uwe, Sandy',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 3);
          expect(sut.applyEntries[0].teilnehmende, '3');
        });

        test('Then beschreibung contains "Januar"', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 21, 18, 30),
            description: 'Teilnehmende: Alex, Uwe, Sandy',
          );

          expect(sut.applyEntries[0].beschreibung, 'Dienstabend Januar (iCal)');
        });
      });
    });

    group('Given a March event without description', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 1 (fallback)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 18, 18, 30),
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 1);
          expect(sut.applyEntries[0].teilnehmende, '');
          expect(sut.applyEntries[0].beschreibung, 'Dienstabend März (iCal)');
        });
      });
    });

    group('Given events in different months', () {
      group('When processEvent is called for each', () {
        test('Then each entry has the correct month name', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 21, 18, 30),
            description: 'Teilnehmende: Alex, Uwe',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 17, 18, 30),
            description: 'Teilnehmende: Sandy',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 12, 16, 18, 30),
          );

          expect(sut.applyEntries, hasLength(3));
          expect(sut.applyEntries[0].beschreibung, 'Dienstabend Januar (iCal)');
          expect(sut.applyEntries[1].beschreibung, 'Dienstabend Juni (iCal)');
          expect(
              sut.applyEntries[2].beschreibung, 'Dienstabend Dezember (iCal)');
        });

        test('Then displayRows shows the total of all entries', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 21, 18, 30),
            description: 'Teilnehmende: Alex, Uwe',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 6, 17, 18, 30),
            description: 'Teilnehmende: Sandy',
          );

          expect(sut.displayRows, hasLength(1));
          expect(sut.displayRows[0].label, 'Dienstabend');
          expect(sut.displayRows[0].value, 3);
        });
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then applyEntries is empty and displayRows shows 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 1, 21, 18, 30),
            description: 'Teilnehmende: Alex',
          );

          sut.reset();

          expect(sut.applyEntries, isEmpty);
          expect(sut.displayRows.first.value, 0);
        });
      });
    });

    group('Given the targetCategoryName', () {
      test('Then it is Ausbildung/Fortbildung', () {
        expect(sut.targetCategoryName, 'Ausbildung/Fortbildung');
      });
    });
  });
}
