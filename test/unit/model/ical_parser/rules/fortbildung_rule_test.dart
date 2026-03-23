import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/fortbildung_rule.dart';

void main() {
  late FortbildungRule sut;

  setUp(() {
    sut = FortbildungRule();
  });

  group('FortbildungRule', () {
    group('Given a summary "Erste Hilfe Kurs (Fortbildung)"', () {
      test('Then matches returns true', () {
        expect(sut.matches('Erste Hilfe Kurs (Fortbildung)'), isTrue);
      });
    });

    group('Given a summary "Fortbildung"', () {
      test('Then matches returns false (needs parentheses)', () {
        expect(sut.matches('Fortbildung'), isFalse);
      });
    });

    group('Given an event with 2 Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 2', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            description: 'Teilnehmende: Max, Erika',
            summary: 'Erste Hilfe Kurs (Fortbildung)',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 2);
          expect(sut.applyEntries[0].teilnehmende, '2');
          expect(sut.applyEntries[0].beschreibung,
              'Erste Hilfe Kurs (Fortbildung) (iCal)');
        });
      });
    });

    group('Given an event without description', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 1', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            summary: 'Sanitätskurs (Fortbildung)',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 1);
          expect(sut.applyEntries[0].teilnehmende, '');
        });
      });
    });

    group('Given multiple events', () {
      group('When processEvent is called for each', () {
        test('Then each event creates a separate entry', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            description: 'Teilnehmende: Max, Erika',
            summary: 'Erste Hilfe (Fortbildung)',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 15, 9, 0),
            summary: 'Sanitätskurs (Fortbildung)',
          );

          expect(sut.applyEntries, hasLength(2));
          expect(sut.applyEntries[0].beschreibung,
              'Erste Hilfe (Fortbildung) (iCal)');
          expect(sut.applyEntries[1].beschreibung,
              'Sanitätskurs (Fortbildung) (iCal)');
        });

        test('Then displayRows shows the total', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 9, 0),
            description: 'Teilnehmende: Max, Erika',
            summary: 'Erste Hilfe (Fortbildung)',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 15, 9, 0),
            summary: 'Sanitätskurs (Fortbildung)',
          );

          expect(sut.displayRows, hasLength(1));
          expect(sut.displayRows[0].value, 3);
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
            summary: 'Test (Fortbildung)',
          );

          sut.reset();

          expect(sut.applyEntries, isEmpty);
          expect(sut.displayRows.first.value, 0);
        });
      });
    });
  });
}
