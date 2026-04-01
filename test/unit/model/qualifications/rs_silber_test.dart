import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/model/qualifications/qualification_validity.dart';
import 'package:training_organizer/model/qualifications/rs_silber.dart';

void main() {
  group('RsSilber', () {
    group('Given a null date', () {
      group('When isUp2Date is called', () {
        test('Then it should return expired', () {
          final rsSilber = RsSilber(null);

          expect(rsSilber.isUp2Date, QualificationValidity.expired);
        });
      });
    });

    group('Given a date more than 2 years ago', () {
      group('When isUp2Date is called', () {
        test('Then it should return expired', () {
          final date = DateTime.now().subtract(const Duration(days: 731));
          final rsSilber = RsSilber(date);

          expect(rsSilber.isUp2Date, QualificationValidity.expired);
        });
      });
    });

    group('Given a date exactly 730 days ago', () {
      group('When isUp2Date is called', () {
        test('Then it should return expired', () {
          final date = DateTime.now().subtract(const Duration(days: 730));
          final rsSilber = RsSilber(date);

          expect(rsSilber.isUp2Date, QualificationValidity.expired);
        });
      });
    });

    group('Given a date 729 days ago', () {
      group('When isUp2Date is called', () {
        test('Then it should return expiring', () {
          final date = DateTime.now().subtract(const Duration(days: 729));
          final rsSilber = RsSilber(date);

          expect(rsSilber.isUp2Date, QualificationValidity.expiring);
        });
      });
    });

    group('Given a date exactly 400 days ago', () {
      group('When isUp2Date is called', () {
        test('Then it should return expiring', () {
          final date = DateTime.now().subtract(const Duration(days: 400));
          final rsSilber = RsSilber(date);

          expect(rsSilber.isUp2Date, QualificationValidity.expiring);
        });
      });
    });

    group('Given a date 399 days ago', () {
      group('When isUp2Date is called', () {
        test('Then it should return valid', () {
          final date = DateTime.now().subtract(const Duration(days: 399));
          final rsSilber = RsSilber(date);

          expect(rsSilber.isUp2Date, QualificationValidity.valid);
        });
      });
    });

    group('Given a date today', () {
      group('When isUp2Date is called', () {
        test('Then it should return valid', () {
          final date = DateTime.now();
          final rsSilber = RsSilber(date);

          expect(rsSilber.isUp2Date, QualificationValidity.valid);
        });
      });
    });
  });
}
