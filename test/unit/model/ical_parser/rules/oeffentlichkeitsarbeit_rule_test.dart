import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/oeffentlichkeitsarbeit_rule.dart';

void main() {
  late OeffentlichkeitsarbeitRule sut;

  setUp(() {
    sut = OeffentlichkeitsarbeitRule();
  });

  group('OeffentlichkeitsarbeitRule', () {
    group('Given a summary "Tag der offenen Tür (Öffentlichkeitsarbeit)"', () {
      test('Then matches returns true', () {
        expect(
            sut.matches('Tag der offenen Tür (Offentlichkeitsarbeit)'), isTrue);
      });
    });

    group('Given a summary "Öffentlichkeitsarbeit"', () {
      test('Then matches returns false (needs parentheses)', () {
        expect(sut.matches('Öffentlichkeitsarbeit'), isFalse);
      });
    });

    group('Given an event with 3 Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then teilnehmendeCount is 3', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 10, 10, 0),
            description: 'Teilnehmende: Alex, Sandy, Uwe',
          );

          expect(sut.teilnehmendeCount, 3);
        });
      });
    });

    group('Given an event without description', () {
      group('When processEvent is called', () {
        test('Then teilnehmendeCount is 1 (fallback)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 10, 10, 0),
          );

          expect(sut.teilnehmendeCount, 1);
        });
      });
    });

    group('Given events were processed', () {
      group('When applyEntries is accessed', () {
        test('Then it targets Öffentlichkeitsarbeit', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 10, 10, 0),
            description: 'Teilnehmende: Alex, Sandy',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].targetCategoryName,
              OeffentlichkeitsarbeitRule.targetCategory);
          expect(sut.applyEntries[0].value, 2);
        });
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then teilnehmendeCount is 0', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 10, 10, 0),
            description: 'Teilnehmende: Alex',
          );

          sut.reset();

          expect(sut.teilnehmendeCount, 0);
        });
      });
    });
  });
}
