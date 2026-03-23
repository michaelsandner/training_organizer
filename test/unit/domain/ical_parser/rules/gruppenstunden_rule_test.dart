import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/gruppenstunden_rule.dart';

void main() {
  late GruppenstundenRule sut;

  setUp(() {
    sut = GruppenstundenRule();
  });

  group('GruppenstundenRule', () {
    group('Given a summary "Gruppenstunde"', () {
      test('Then matches returns true', () {
        expect(sut.matches('Gruppenstunde'), isTrue);
      });
    });

    group('Given a summary "Gruppenstunde - Jugend"', () {
      test('Then matches returns true', () {
        expect(sut.matches('Gruppenstunde - Jugend'), isTrue);
      });
    });

    group('Given a summary "Gruppenstunde - Jugend (intern)"', () {
      test('Then matches returns true', () {
        expect(sut.matches('Gruppenstunde - Jugend (intern)'), isTrue);
      });
    });

    group('Given a summary "Gruppenstunde Planung"', () {
      test('Then matches returns false', () {
        expect(sut.matches('Gruppenstunde Planung'), isFalse);
      });
    });

    group('Given a summary "Gruppenstunde - Jugend (Abgesagt)"', () {
      test('Then matches returns false', () {
        expect(sut.matches('Gruppenstunde - Jugend (Abgesagt)'), isFalse);
      });
    });

    group('Given a summary with whitespace "  Gruppenstunde  "', () {
      test('Then matches returns true', () {
        expect(sut.matches('  Gruppenstunde  '), isTrue);
      });
    });

    group('Given two events with 2h and 3h duration', () {
      group('When processEvent is called for each', () {
        test('Then eventCount is 2 and totalHours is 5', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 2, 7, 14, 0),
            endDateTime: DateTime(2026, 2, 7, 16, 0),
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 7, 14, 0),
            endDateTime: DateTime(2026, 3, 7, 17, 0),
          );

          expect(sut.eventCount, 2);
          expect(sut.totalHours, 5);
        });
      });
    });

    group('Given events were processed', () {
      group('When displayRows is accessed', () {
        test('Then it contains Anzahl and Stunden rows', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 2, 7, 14, 0),
            endDateTime: DateTime(2026, 2, 7, 16, 0),
          );

          expect(sut.displayRows, hasLength(2));
          expect(
              sut.displayRows[0].label, GruppenstundenRule.displayLabelAnzahl);
          expect(sut.displayRows[0].value, 1);
          expect(
              sut.displayRows[1].label, GruppenstundenRule.displayLabelStunden);
          expect(sut.displayRows[1].value, 2);
        });
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then all counters are 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 2, 7, 14, 0),
            endDateTime: DateTime(2026, 2, 7, 16, 0),
          );

          sut.reset();

          expect(sut.eventCount, 0);
          expect(sut.totalHours, 0);
        });
      });
    });
  });
}
