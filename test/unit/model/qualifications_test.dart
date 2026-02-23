import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/model/qualifications.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/silber.dart';

void main() {
  group('Qualifications', () {
    group('Given a Qualifications object with Pirat and Bronze', () {
      final qualifications = Qualifications(qualifications: [
        Pirat(DateTime(2020, 1, 1)),
        Bronze(DateTime(2021, 2, 2)),
      ]);
      group('When toJson is called', () {
        test('Then it returns the correct map', () {
          expect(qualifications.toJson(), {
            'qualifications': [
              {'name': 'Pirat', 'date': '01.01.2020'},
              {'name': 'Bronze', 'date': '02.02.2021'},
            ]
          });
        });
      });
    });

    group('Given a JSON list', () {
      final json = [
        {'name': 'Silber', 'date': '03.03.2022'},
        {'name': 'Gold', 'date': null},
      ];
      group('When fromJson is called', () {
        final qualifications = Qualifications.fromJson(json);
        test('Then it creates the correct Qualifications object', () {
          expect(qualifications.qualifications.length, 2);
          expect(qualifications.qualifications[0].name, 'Silber');
          expect(qualifications.qualifications[0].date, DateTime(2022, 3, 3));
          expect(qualifications.qualifications[1].name, 'Gold');
          expect(qualifications.qualifications[1].date, null);
        });
      });
    });

    group('Given a Qualifications object with Silber(2022)', () {
      final qualifications = Qualifications(qualifications: [
        Silber(DateTime(2022, 5, 5)),
      ]);
      group('When hasQualificationFromYear is called', () {
        test('Then it returns true for 2022', () {
          expect(
              qualifications.hasQualificationFromYear('Silber', 2022), isTrue);
        });
        test('Then it returns false for 2021', () {
          expect(
              qualifications.hasQualificationFromYear('Silber', 2021), isFalse);
        });
      });
    });

    group('Given a Qualifications object with Gold', () {
      final qualifications = Qualifications(qualifications: [
        Gold(DateTime(2023, 1, 1)),
      ]);
      group('When hasQualification is called', () {
        test('Then it returns true for Gold', () {
          expect(qualifications.hasQualification('Gold'), isTrue);
        });
        test('Then it returns false for Silber', () {
          expect(qualifications.hasQualification('Silber'), isFalse);
        });
      });
    });

    group('Given Qualifications objects with different highest qualifications',
        () {
      final q1 = Qualifications(qualifications: [Pirat(null)]);
      final q2 = Qualifications(qualifications: [Bronze(null)]);
      final q3 = Qualifications(qualifications: [Silber(null)]);
      final q4 = Qualifications(qualifications: [Gold(null)]);
      final q5 = const Qualifications();
      group('When getHighestQualification is called', () {
        test('Then it returns the correct short name for Pirat', () {
          expect(q1.getHighestQualification(), 'P');
        });
        test('Then it returns the correct short name for Bronze', () {
          expect(q2.getHighestQualification(), 'B');
        });
        test('Then it returns the correct short name for Silber', () {
          expect(q3.getHighestQualification(), 'S');
        });
        test('Then it returns the correct short name for Gold', () {
          expect(q4.getHighestQualification(), 'G');
        });
        test('Then it returns an empty string for none', () {
          expect(q5.getHighestQualification(), '');
        });
      });
    });

    group('Given two Qualifications objects with identical lists', () {
      final q1 = Qualifications(qualifications: [Pirat(null), Bronze(null)]);
      final q2 = Qualifications(qualifications: [Pirat(null), Bronze(null)]);
      test('Then equality operator returns true', () {
        expect(q1, q2);
      });
    });

    group('Given two Qualifications objects with different lists', () {
      final q1 = Qualifications(qualifications: [Pirat(null)]);
      final q2 = Qualifications(qualifications: [Bronze(null)]);
      test('Then equality operator returns false', () {
        expect(q1 == q2, isFalse);
      });
    });
  });
}
