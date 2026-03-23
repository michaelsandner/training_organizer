import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/gremienarbeit_rule.dart';

void main() {
  late GremienarbeitRule sut;

  setUp(() {
    sut = GremienarbeitRule();
  });

  group('GremienarbeitRule', () {
    group('Given a summary "Vorstandssitzung (Gremienarbeit)"', () {
      test('Then matches returns true', () {
        expect(sut.matches('Vorstandssitzung (Gremienarbeit)'), isTrue);
      });
    });

    group('Given a summary "Gremienarbeit"', () {
      test('Then matches returns false (needs parentheses)', () {
        expect(sut.matches('Gremienarbeit'), isFalse);
      });
    });

    group('Given an event with 2 hours duration', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 2 (hours)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 5, 18, 0),
            endDateTime: DateTime(2026, 3, 5, 20, 0),
            summary: 'Vorstandssitzung (Gremienarbeit)',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 2);
          expect(sut.applyEntries[0].beschreibung,
              'Vorstandssitzung (Gremienarbeit) (iCal)');
        });
      });
    });

    group('Given an event without endDateTime', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 5, 18, 0),
            summary: 'Sitzung (Gremienarbeit)',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 0);
        });
      });
    });

    group('Given an event with 90 minute duration', () {
      group('When processEvent is called', () {
        test('Then hours are rounded up to 2', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 5, 18, 0),
            endDateTime: DateTime(2026, 3, 5, 19, 30),
            summary: 'Sitzung (Gremienarbeit)',
          );

          expect(sut.applyEntries[0].value, 2);
        });
      });
    });

    group('Given multiple events', () {
      group('When processEvent is called for each', () {
        test('Then each event creates a separate entry', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 5, 18, 0),
            endDateTime: DateTime(2026, 3, 5, 20, 0),
            summary: 'Vorstandssitzung (Gremienarbeit)',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 18, 0),
            endDateTime: DateTime(2026, 4, 10, 21, 0),
            summary: 'Jahresplanung (Gremienarbeit)',
          );

          expect(sut.applyEntries, hasLength(2));
          expect(sut.displayRows.first.value, 5);
        });
      });
    });

    group('Given the targetCategoryName', () {
      test('Then it is Gremienarbeit', () {
        expect(sut.targetCategoryName, 'Gremienarbeit');
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then applyEntries is empty', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 5, 18, 0),
            endDateTime: DateTime(2026, 3, 5, 20, 0),
            summary: 'Test (Gremienarbeit)',
          );

          sut.reset();

          expect(sut.applyEntries, isEmpty);
          expect(sut.displayRows.first.value, 0);
        });
      });
    });
  });
}
