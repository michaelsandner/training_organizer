import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/model/badge.dart';

void main() {
  group('Badge', () {
    test('initial values', () {
      final bronzeBadge = BronzeBadge(null);

      expect(bronzeBadge.date, null);
      expect(bronzeBadge.hasBadge, false);
    });

    test('get name', () {
      final bronzeBadge = BronzeBadge(null);

      expect(bronzeBadge.name, 'Bronze');
    });

    test('setBadge', () {
      final bronzeBadge = BronzeBadge(null);

      bronzeBadge.setBadge(DateTime(2020, 9, 9, 9));

      expect(bronzeBadge.hasBadge, true);
      expect(bronzeBadge.date!.year, 2020);
    });

    group('toJson', () {
      group('when date is null', () {
        test('should store null', () {
          final bronzeBadge = BronzeBadge(null);
          final expectedJson = {
            'name': 'Bronze',
            'date': null,
          };

          expect(bronzeBadge.toJson(), expectedJson);
        });
      });

      group('when date is valid', () {
        test('should store date', () {
          final bronzeBadge = BronzeBadge(null);
          bronzeBadge.setBadge(DateTime(2020, 9, 9));
          final expectedJson = {
            'name': 'Bronze',
            'date': '09.09.2020',
          };

          expect(bronzeBadge.toJson(), expectedJson);
        });
      });
    });

    group('fromJson', () {
      group('when date is not null', () {
        test('should parse date', () {
          final inputJson = {
            'name': 'Bronze',
            'date': '09.09.2020',
          };

          final badge = BronzeBadge.fromJson(inputJson);

          expect(badge.name, 'Bronze');
          expect(badge.date, (DateTime(2020, 9, 9)));
        });
      });

      group('when date has wrong format', () {
        test('should set null', () {
          final inputJson = {
            'name': 'Bronze',
            'date': '2000-10-10',
          };

          final badge = BronzeBadge.fromJson(inputJson);

          expect(badge.name, 'Bronze');
          expect(badge.date, null);
        });
      });

      group('when date is null', () {
        test('should set null', () {
          final inputJson = {
            'name': 'Bronze',
            'date': null,
          };

          final badge = BronzeBadge.fromJson(inputJson);

          expect(badge.name, 'Bronze');
          expect(badge.date, null);
        });
      });
    });

    group('isUpToDate', () {
      group('When is older than two years', () {
        test('returns false', () {
          final bronzeBadge = BronzeBadge(null);
          final date = DateTime(DateTime.now().year - 2, DateTime.now().month,
              DateTime.now().day - 2);
          bronzeBadge.setBadge(date);

          expect(bronzeBadge.isUpToDate, false);
        });
      });

      group('When is younger than two years', () {
        test('returns true', () {
          final bronzeBadge = BronzeBadge(null);
          final date = DateTime(DateTime.now().year - 2, DateTime.now().month,
              DateTime.now().day + 1);
          bronzeBadge.setBadge(date);

          expect(bronzeBadge.isUpToDate, true);
        });
      });
    });
  });
}
