import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/rettungsschwimmausbildung_rule.dart';

void main() {
  late RettungsschwimmausbildungRule sut;

  setUp(() {
    sut = RettungsschwimmausbildungRule();
  });

  group('RettungsschwimmausbildungRule', () {
    group('Given a summary "Rettungsschwimmausbildung"', () {
      test('Then matches returns true', () {
        expect(sut.matches('Rettungsschwimmausbildung'), isTrue);
      });
    });

    group('Given a summary "Rettungsschwimmausbildung Kinder"', () {
      test('Then matches returns true (contains match)', () {
        expect(sut.matches('Rettungsschwimmausbildung Kinder'), isTrue);
      });
    });

    group('Given a summary "Schwimmtraining"', () {
      test('Then matches returns false', () {
        expect(sut.matches('Schwimmtraining'), isFalse);
      });
    });

    group('Given an event with 2 Teilnehmende and 2 hours', () {
      group('When processEvent is called', () {
        test('Then total is 4 (2 hours × 2 participants)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            endDateTime: DateTime(2026, 3, 10, 20, 0),
            description: 'Teilnehmende: Max, Erika',
          );

          expect(sut.total, 4);
        });
      });
    });

    group('Given an event without description and 2 hours', () {
      group('When processEvent is called', () {
        test('Then total is 2 (2 hours × 1 fallback)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            endDateTime: DateTime(2026, 3, 10, 20, 0),
          );

          expect(sut.total, 2);
        });
      });
    });

    group('Given an event without endDateTime and 2 Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then total is 2 (fallback to count only)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            description: 'Teilnehmende: Max, Erika',
          );

          expect(sut.total, 2);
        });
      });
    });

    group('Given multiple events with participants and hours', () {
      group('When processEvent is called for each', () {
        test('Then total is the sum of hours × participants', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            endDateTime: DateTime(2026, 3, 10, 20, 0),
            description: 'Teilnehmende: Max, Erika',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 17, 18, 0),
            endDateTime: DateTime(2026, 3, 17, 19, 30),
            description: 'Teilnehmende: Tom',
          );

          // Event 1: 2h × 2 = 4, Event 2: ceil(1.5h) × 1 = 2
          expect(sut.total, 6);
        });
      });
    });

    group('Given events were processed', () {
      group('When applyEntries is accessed', () {
        test('Then it targets Ausbildung/Fortbildung with correct total', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            endDateTime: DateTime(2026, 3, 10, 20, 0),
            description: 'Teilnehmende: Max, Erika',
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
        test('Then total is 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 10, 18, 0),
            endDateTime: DateTime(2026, 3, 10, 20, 0),
            description: 'Teilnehmende: Max',
          );

          sut.reset();

          expect(sut.total, 0);
        });
      });
    });
  });
}
