import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/mixins/event_time_mixin.dart';

class _TestEventTime with EventTimeMixin {}

void main() {
  late _TestEventTime sut;

  setUp(() {
    sut = _TestEventTime();
  });

  group('EventTimeMixin', () {
    group('Given a fresh instance', () {
      test('Then totalHours is 0', () {
        expect(sut.totalHours, 0);
      });
    });

    group('Given an event with 90 minutes duration', () {
      group('When trackEventTime is called', () {
        test('Then totalHours is 2 (rounded up)', () {
          final start = DateTime(2026, 1, 10, 18, 0);
          final end = DateTime(2026, 1, 10, 19, 30);

          sut.trackEventTime(start, end);

          expect(sut.totalHours, 2);
        });
      });
    });

    group('Given an event with exactly 2 hours duration', () {
      group('When trackEventTime is called', () {
        test('Then totalHours is 2', () {
          final start = DateTime(2026, 1, 10, 18, 0);
          final end = DateTime(2026, 1, 10, 20, 0);

          sut.trackEventTime(start, end);

          expect(sut.totalHours, 2);
        });
      });
    });

    group('Given an event with null endDateTime', () {
      group('When trackEventTime is called', () {
        test('Then totalHours stays 0', () {
          final start = DateTime(2026, 1, 10, 18, 0);

          sut.trackEventTime(start, null);

          expect(sut.totalHours, 0);
        });
      });
    });

    group('Given multiple events', () {
      group('When trackEventTime is called for each', () {
        test('Then totalHours is the sum', () {
          sut.trackEventTime(
            DateTime(2026, 1, 10, 18, 0),
            DateTime(2026, 1, 10, 20, 0),
          );
          sut.trackEventTime(
            DateTime(2026, 1, 17, 18, 0),
            DateTime(2026, 1, 17, 21, 0),
          );

          expect(sut.totalHours, 5);
        });
      });
    });

    group('Given trackEventTime was called', () {
      group('When resetEventTime is called', () {
        test('Then totalHours is 0', () {
          sut.trackEventTime(
            DateTime(2026, 1, 10, 18, 0),
            DateTime(2026, 1, 10, 20, 0),
          );

          sut.resetEventTime();

          expect(sut.totalHours, 0);
        });
      });
    });
  });
}
