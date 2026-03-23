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

    group('Given a description with Teilnehmende:3', () {
      group('When trackTeilnehmende is called', () {
        test('Then teilnehmendeCount is 3', () {
          sut.trackTeilnehmende('Teilnehmende:3');

          expect(sut.teilnehmendeCount, 3);
        });
      });
    });

    group('Given a description with "Teilnehmende: 5" (with space)', () {
      group('When trackTeilnehmende is called', () {
        test('Then teilnehmendeCount is 5', () {
          sut.trackTeilnehmende('Teilnehmende: 5');

          expect(sut.teilnehmendeCount, 5);
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

    group('Given multiple events with participant counts', () {
      group('When trackTeilnehmende is called for each', () {
        test('Then teilnehmendeCount is the sum', () {
          sut.trackTeilnehmende('Teilnehmende:2');
          sut.trackTeilnehmende('Teilnehmende: 1');

          expect(sut.teilnehmendeCount, 3);
        });
      });
    });

    group('Given trackTeilnehmende was called', () {
      group('When resetTeilnehmendeCount is called', () {
        test('Then teilnehmendeCount is 0', () {
          sut.trackTeilnehmende('Teilnehmende:2');

          sut.resetTeilnehmendeCount();

          expect(sut.teilnehmendeCount, 0);
        });
      });
    });

    group('Given a description with text before the marker', () {
      group('When trackTeilnehmende is called', () {
        test('Then count after Teilnehmende: is parsed', () {
          sut.trackTeilnehmende(
              'Tag:Fortbildung\nTeilnehmende: 3');

          expect(sut.teilnehmendeCount, 3);
        });
      });
    });

    group('Given a description with lowercase "teilnehmende: 4"', () {
      group('When trackTeilnehmende is called', () {
        test('Then count is parsed case-insensitively', () {
          sut.trackTeilnehmende('teilnehmende: 4');

          expect(sut.teilnehmendeCount, 4);
        });
      });
    });
  });
}
