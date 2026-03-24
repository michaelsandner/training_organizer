import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/oeffentlichkeitsarbeit_rule.dart';

void main() {
  late OeffentlichkeitsarbeitRule sut;

  setUp(() {
    sut = OeffentlichkeitsarbeitRule();
  });

  group('OeffentlichkeitsarbeitRule', () {
    group('Given a description with "Tag:Öffentlichkeitsarbeit"', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Tag der offenen Tür',
                description: 'Tag:Öffentlichkeitsarbeit'),
            isTrue);
      });
    });

    group('Given a description with "tag: öffentlichkeitsarbeit" (lower case)',
        () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Tag der offenen Tür',
                description: 'tag: öffentlichkeitsarbeit'),
            isTrue);
      });
    });

    group('Given a description with non-breaking space after Tag:', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Tag der offenen Tür',
                description: 'Tag:\u00a0Öffentlichkeitsarbeit'),
            isTrue);
      });
    });

    group('Given no description', () {
      test('Then matches returns false', () {
        expect(sut.matches(summary: 'Öffentlichkeitsarbeit'), isFalse);
      });
    });

    group('Given an event with Teilnehmende:3 and 2 hours', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 6 (2h × 3)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 10, 10, 0),
            endDateTime: DateTime(2026, 5, 10, 12, 0),
            description: 'Tag:Öffentlichkeitsarbeit\nTeilnehmende:3',
            summary: 'Tag der offenen Tür',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 6);
          expect(sut.applyEntries[0].teilnehmende, '3');
          expect(sut.applyEntries[0].targetCategoryName,
              OeffentlichkeitsarbeitRule.targetCategory);
        });
      });
    });

    group('Given an event without Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then value uses 1 as participant count', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 10, 10, 0),
            endDateTime: DateTime(2026, 5, 10, 12, 0),
            description: 'Tag: Öffentlichkeitsarbeit',
            summary: 'Infoveranstaltung',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 2);
        });
      });
    });

    group('Given events were processed', () {
      group('When applyEntries is accessed', () {
        test('Then it targets Öffentlichkeitsarbeit with date', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 10, 10, 0),
            endDateTime: DateTime(2026, 5, 10, 12, 0),
            description: 'Tag:Öffentlichkeitsarbeit\nTeilnehmende: 2',
            summary: 'Tag der offenen Tür',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].targetCategoryName,
              OeffentlichkeitsarbeitRule.targetCategory);
          expect(sut.applyEntries[0].value, 4);
          expect(sut.applyEntries[0].beschreibung,
              'Tag der offenen Tür 10.05.2026 (iCal)');
        });
      });
    });

    group('Given events were processed', () {
      group('When reset is called', () {
        test('Then applyEntries is empty', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 5, 10, 10, 0),
            endDateTime: DateTime(2026, 5, 10, 12, 0),
            description: 'Tag:Öffentlichkeitsarbeit',
            summary: 'Test',
          );

          sut.reset();

          expect(sut.applyEntries, isEmpty);
          expect(sut.displayRows.first.value, 0);
        });
      });
    });
  });
}
