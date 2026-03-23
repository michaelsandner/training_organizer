import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/gremienarbeit_rule.dart';

void main() {
  late GremienarbeitRule sut;

  setUp(() {
    sut = GremienarbeitRule();
  });

  group('GremienarbeitRule', () {
    group('Given a description with "Tag:Gremienarbeit"', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Vorstandssitzung',
                description: 'Tag:Gremienarbeit'),
            isTrue);
      });
    });

    group('Given a description with "tag: gremienarbeit" (lowercase)', () {
      test('Then matches returns true', () {
        expect(
            sut.matches(
                summary: 'Vorstandssitzung',
                description: 'tag: gremienarbeit'),
            isTrue);
      });
    });

    group('Given no description', () {
      test('Then matches returns false', () {
        expect(sut.matches(summary: 'Gremienarbeit'), isFalse);
      });
    });

    group('Given an event with 2 hours duration and Teilnehmende:3', () {
      group('When processEvent is called', () {
        test('Then applyEntries has one entry with value 6 (2h × 3)', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 5, 18, 0),
            endDateTime: DateTime(2026, 3, 5, 20, 0),
            description: 'Tag:Gremienarbeit\nTeilnehmende:3',
            summary: 'Vorstandssitzung',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 6);
          expect(sut.applyEntries[0].beschreibung,
              'Vorstandssitzung 05.03.2026 (iCal)');
        });
      });
    });

    group('Given an event without Teilnehmende', () {
      group('When processEvent is called', () {
        test('Then value uses 1 as participant count', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 5, 18, 0),
            endDateTime: DateTime(2026, 3, 5, 20, 0),
            description: 'Tag:Gremienarbeit',
            summary: 'Sitzung',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 2);
        });
      });
    });

    group('Given an event without endDateTime', () {
      group('When processEvent is called', () {
        test('Then value falls back to participant count', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 5, 18, 0),
            description: 'Tag:Gremienarbeit\nTeilnehmende: 2',
            summary: 'Sitzung',
          );

          expect(sut.applyEntries, hasLength(1));
          expect(sut.applyEntries[0].value, 2);
        });
      });
    });

    group('Given an event with 90 minute duration', () {
      group('When processEvent is called', () {
        test('Then hours are rounded up to 2', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 5, 18, 0),
            endDateTime: DateTime(2026, 3, 5, 19, 30),
            description: 'Tag:Gremienarbeit',
            summary: 'Sitzung',
          );

          expect(sut.applyEntries[0].value, 2);
        });
      });
    });

    group('Given multiple events', () {
      group('When processEvent is called for each', () {
        test('Then each event creates a separate entry with date', () {
          sut.processEvent(
            startDateTime: DateTime(2026, 3, 5, 18, 0),
            endDateTime: DateTime(2026, 3, 5, 20, 0),
            description: 'Tag:Gremienarbeit\nTeilnehmende: 2',
            summary: 'Vorstandssitzung',
          );
          sut.processEvent(
            startDateTime: DateTime(2026, 4, 10, 18, 0),
            endDateTime: DateTime(2026, 4, 10, 21, 0),
            description: 'Tag:Gremienarbeit',
            summary: 'Jahresplanung',
          );

          expect(sut.applyEntries, hasLength(2));
          // 2h × 2 = 4, 3h × 1 = 3 → total = 7
          expect(sut.displayRows.first.value, 7);
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
            description: 'Tag:Gremienarbeit',
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
