import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/teilnehmende_mixin.dart';

class _TestTeilnehmende with TeilnehmendeMixin {}

void main() {
  late _TestTeilnehmende sut;

  setUp(() {
    sut = _TestTeilnehmende();
  });

  group('TeilnehmendeMixin', () {
    group('Given a fresh instance', () {
      test('Then teilnehmendeCount is 0', () {
        expect(sut.teilnehmendeCount, 0);
      });
    });

    group('Given a description with Teilnehmende marker and 3 names', () {
      group('When trackTeilnehmende is called', () {
        test('Then teilnehmendeCount is 3', () {
          sut.trackTeilnehmende('Teilnehmende: Alex, Uwe, Sandy');

          expect(sut.teilnehmendeCount, 3);
        });
      });
    });

    group('Given a null description', () {
      group('When trackTeilnehmende is called', () {
        test('Then teilnehmendeCount is 1 (fallback)', () {
          sut.trackTeilnehmende(null);

          expect(sut.teilnehmendeCount, 1);
        });
      });
    });

    group('Given a description without Teilnehmende marker', () {
      group('When trackTeilnehmende is called', () {
        test('Then teilnehmendeCount is 1 (fallback)', () {
          sut.trackTeilnehmende('Just some text');

          expect(sut.teilnehmendeCount, 1);
        });
      });
    });

    group('Given multiple events with participants', () {
      group('When trackTeilnehmende is called for each', () {
        test('Then teilnehmendeCount is the sum', () {
          sut.trackTeilnehmende('Teilnehmende: Alex, Uwe');
          sut.trackTeilnehmende('Teilnehmende: Sandy');

          expect(sut.teilnehmendeCount, 3);
        });
      });
    });

    group('Given trackTeilnehmende was called', () {
      group('When resetTeilnehmendeCount is called', () {
        test('Then teilnehmendeCount is 0', () {
          sut.trackTeilnehmende('Teilnehmende: Alex, Uwe');

          sut.resetTeilnehmendeCount();

          expect(sut.teilnehmendeCount, 0);
        });
      });
    });

    group('Given a description with text before the marker', () {
      group('When trackTeilnehmende is called', () {
        test('Then names after Teilnehmende: are counted', () {
          sut.trackTeilnehmende(
              'https://trello.com/abc\nTeilnehmende: Alex, Uwe, Sandy');

          expect(sut.teilnehmendeCount, 3);
        });
      });
    });

    group('Given a description with text after names on next line', () {
      group('When trackTeilnehmende is called', () {
        test('Then only names on the Teilnehmende line are counted', () {
          sut.trackTeilnehmende('Teilnehmende: Alex, Uwe\nSome other content');

          expect(sut.teilnehmendeCount, 2);
        });
      });
    });
  });
}
