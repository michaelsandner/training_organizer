import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/rettungsschwimmausbildung_rule.dart';

void main() {
  late RettungsschwimmausbildungRule sut;

  setUp(() {
    sut = RettungsschwimmausbildungRule();
  });

  group('RettungsschwimmausbildungRule', () {
    group('Given a summary "Rettungsschwimmausbildung"', () {
      test('Then matches returns true', () {
        expect(sut.matches(summary: 'Rettungsschwimmausbildung'), isTrue);
      });
    });

    group('Given a summary "Rettungsschwimmausbildung Kinder"', () {
      test('Then matches returns true (contains match)', () {
        expect(
            sut.matches(summary: 'Rettungsschwimmausbildung Kinder'), isTrue);
      });
    });

    group('Given a summary "Schwimmtraining"', () {
      test('Then matches returns false', () {
        expect(sut.matches(summary: 'Schwimmtraining'), isFalse);
      });
    });

    group('Given an event with 2 Teilnehmende and 2 hours', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 4 and date', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            endDateTime: DateTime(2026, 3, 10, 20, 0),
            description: 'Teilnehmende: Max, Erika',
            summary: 'Rettungsschwimmausbildung',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 4);
          expect(sut.applyEntries[0].beschreibung,
              'Rettungsschwimmausbildung 10.03.2026 (iCal)');
        });
      });
    });

    group('Given an event without description and 2 hours', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 2', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            endDateTime: DateTime(2026, 3, 10, 20, 0),
            summary: 'Rettungsschwimmausbildung',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 2);
        });
      });
    });

    group('Given an event without endDateTime and 2 Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 2', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            description: 'Teilnehmende: Max, Erika',
            summary: 'Rettungsschwimmausbildung',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 2);
        });
      });
    });

    group('Given multiple events with participants and hours', () {
      group('When processEvent is called for each', () {
        test('Then each event has its own entry with date', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            endDateTime: DateTime(2026, 3, 10, 20, 0),
            description: 'Teilnehmende: Max, Erika',
            summary: 'Rettungsschwimmausbildung',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 17, 18, 0),
            endDateTime: DateTime(2026, 3, 17, 19, 30),
            description: 'Teilnehmende: Tom',
            summary: 'Rettungsschwimmausbildung',
          );

          expect(sut.applyEntries, hasLength(2));
          // Event 1: 2h × 2 = 4
          expect(sut.applyEntries[0].value, 4);
          expect(sut.applyEntries[0].beschreibung,
              'Rettungsschwimmausbildung 10.03.2026 (iCal)');
          // Event 2: ceil(1.5h) × 1 = 2
          expect(sut.applyEntries[1].value, 2);
          expect(sut.applyEntries[1].beschreibung,
              'Rettungsschwimmausbildung 17.03.2026 (iCal)');
          // Total via displayRows
          expect(sut.displayRows[0].value, 6);
        });
      });
    });

    group('Given events were processed', () {
      group('When applyEntries is accessed', () {
        test('Then each entry targets Ausbildung/Fortbildung', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            endDateTime: DateTime(2026, 3, 10, 20, 0),
            description: 'Teilnehmende: Max, Erika',
            summary: 'Rettungsschwimmausbildung',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].targetCategoryName,
              RettungsschwimmausbildungRule.targetCategory);
          expect(sut.applyEntries[0].value, 4);
        });
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then perEventTotal is 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            endDateTime: DateTime(2026, 3, 10, 20, 0),
            description: 'Teilnehmende: Max',
            summary: 'Rettungsschwimmausbildung',
          );

          sut.reset();

          expect(sut.perEventTotal, 0);
        });
      });
    });
  });
}
