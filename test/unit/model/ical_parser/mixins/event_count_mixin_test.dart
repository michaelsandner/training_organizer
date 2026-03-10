import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/mixins/event_count_mixin.dart';

class _TestEventCount with EventCountMixin {}

void main() {
  late _TestEventCount sut;

  setUp(() {
    sut = _TestEventCount();
  });

  group('EventCountMixin', () {
    group('Given a fresh instance', () {
      test('Then eventCount is 0', () {
        expect(sut.eventCount, 0);
      });
    });

    group('Given trackEventCount is called multiple times', () {
      group('When called 3 times', () {
        test('Then eventCount is 3', () {
          sut.trackEventCount();
          sut.trackEventCount();
          sut.trackEventCount();

          expect(sut.eventCount, 3);
        });
      });
    });

    group('Given trackEventCount was called', () {
      group('When resetEventCount is called', () {
        test('Then eventCount is 0', () {
          sut.trackEventCount();
          sut.trackEventCount();

          sut.resetEventCount();

          expect(sut.eventCount, 0);
        });
      });
    });
  });
}
