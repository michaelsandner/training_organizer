import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/model/qualifications.dart';
import 'package:training_organizer/model/qualifications/assitent.dart';
import 'package:training_organizer/model/qualifications/ausbilder_r1.dart';
import 'package:training_organizer/model/qualifications/ausbilder_r2.dart';
import 'package:training_organizer/model/qualifications/ausbilder_s1.dart';
import 'package:training_organizer/model/qualifications/ausbilder_s2.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';
import 'package:training_organizer/model/qualifications/rs_bronze.dart';
import 'package:training_organizer/model/qualifications/rs_silber.dart';
import 'package:training_organizer/model/qualifications/rsiwrd.dart';
import 'package:training_organizer/model/qualifications/san.dart';
import 'package:training_organizer/model/qualifications/silber.dart';
import 'package:training_organizer/model/qualifications/wasserretter.dart';

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

    group(
        'Given a Qualifications object with Ausbildungsassistent and no Ausbilder',
        () {
      final qualifications = Qualifications(
        qualifications: [Assistent(null)],
      );
      group(
          'When hasQualificationAndNoHigherQualification is called with ausbildungsAssistent',
          () {
        test('Then it returns true', () {
          expect(
            qualifications
                .hasQualificationAndNoHigherQualification(ausbildungsAssistent),
            isTrue,
          );
        });
      });
    });

    group(
        'Given a Qualifications object with Ausbildungsassistent and AusbilderS1',
        () {
      final qualifications = Qualifications(
        qualifications: [Assistent(null), AusbilderS1(null)],
      );
      group(
          'When hasQualificationAndNoHigherQualification is called with ausbildungsAssistent',
          () {
        test('Then it returns false', () {
          expect(
            qualifications
                .hasQualificationAndNoHigherQualification(ausbildungsAssistent),
            isFalse,
          );
        });
      });
    });

    group(
        'Given a Qualifications object with Ausbildungsassistent and AusbilderS2',
        () {
      final qualifications = Qualifications(
        qualifications: [Assistent(null), AusbilderS2(null)],
      );
      group(
          'When hasQualificationAndNoHigherQualification is called with ausbildungsAssistent',
          () {
        test('Then it returns false', () {
          expect(
            qualifications
                .hasQualificationAndNoHigherQualification(ausbildungsAssistent),
            isFalse,
          );
        });
      });
    });

    group(
        'Given a Qualifications object with Ausbildungsassistent and AusbilderR1',
        () {
      final qualifications = Qualifications(
        qualifications: [Assistent(null), AusbilderR1(null)],
      );
      group(
          'When hasQualificationAndNoHigherQualification is called with ausbildungsAssistent',
          () {
        test('Then it returns false', () {
          expect(
            qualifications
                .hasQualificationAndNoHigherQualification(ausbildungsAssistent),
            isFalse,
          );
        });
      });
    });

    group(
        'Given a Qualifications object with Ausbildungsassistent and AusbilderR2',
        () {
      final qualifications = Qualifications(
        qualifications: [Assistent(null), AusbilderR2(null)],
      );
      group(
          'When hasQualificationAndNoHigherQualification is called with ausbildungsAssistent',
          () {
        test('Then it returns false', () {
          expect(
            qualifications
                .hasQualificationAndNoHigherQualification(ausbildungsAssistent),
            isFalse,
          );
        });
      });
    });

    group('Given a Qualifications object without Ausbildungsassistent', () {
      final qualifications = Qualifications(
        qualifications: [Gold(null)],
      );
      group(
          'When hasQualificationAndNoHigherQualification is called with ausbildungsAssistent',
          () {
        test('Then it returns false', () {
          expect(
            qualifications
                .hasQualificationAndNoHigherQualification(ausbildungsAssistent),
            isFalse,
          );
        });
      });
    });

    group('Given a Qualifications object with Gold', () {
      final qualifications = Qualifications(
        qualifications: [Gold(null)],
      );
      group('When hasQualificationAndNoHigherQualification is called with gold',
          () {
        test('Then it returns true', () {
          expect(
            qualifications.hasQualificationAndNoHigherQualification(gold),
            isTrue,
          );
        });
      });
    });

    group('Given a Qualifications object without Gold', () {
      final qualifications = Qualifications(
        qualifications: [Silber(null)],
      );
      group('When hasQualificationAndNoHigherQualification is called with gold',
          () {
        test('Then it returns false', () {
          expect(
            qualifications.hasQualificationAndNoHigherQualification(gold),
            isFalse,
          );
        });
      });
    });

    group('Given a Qualifications object with no qualifications', () {
      final qualifications = const Qualifications();
      group('When getOnlyHighestQualifications is called', () {
        test('Then it returns an empty list', () {
          expect(qualifications.getOnlyHighestQualifications(), isEmpty);
        });
      });
    });

    group('Given a Qualifications object with RettungsschwimmerBronze only',
        () {
      final rsBronze = RsBronze(null);
      final qualifications = Qualifications(
        qualifications: [rsBronze],
      );
      group('When getOnlyHighestQualifications is called', () {
        test('Then RettungsschwimmerBronze is kept', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            contains(rsBronze),
          );
        });
      });
    });

    group(
        'Given a Qualifications object with RettungsschwimmerBronze and RettungsschwimmerSilber',
        () {
      final rsBronze = RsBronze(null);
      final rsSilber = RsSilber(null);
      final qualifications = Qualifications(
        qualifications: [rsBronze, rsSilber],
      );
      group('When getOnlyHighestQualifications is called', () {
        test('Then RettungsschwimmerBronze is removed', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            isNot(contains(rsBronze)),
          );
        });
        test('Then RettungsschwimmerSilber is kept', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            contains(rsSilber),
          );
        });
      });
    });

    group(
        'Given a Qualifications object with Ausbildungsassistent and no Ausbilder',
        () {
      final assistent = Assistent(null);
      final qualifications = Qualifications(
        qualifications: [assistent],
      );
      group('When getOnlyHighestQualifications is called', () {
        test('Then Ausbildungsassistent is kept', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            contains(assistent),
          );
        });
      });
    });

    group(
        'Given a Qualifications object with Ausbildungsassistent and AusbilderS1',
        () {
      final assistent = Assistent(null);
      final ausbilder = AusbilderS1(null);
      final qualifications = Qualifications(
        qualifications: [assistent, ausbilder],
      );
      group('When getOnlyHighestQualifications is called', () {
        test('Then Ausbildungsassistent is removed', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            isNot(contains(assistent)),
          );
        });
        test('Then AusbilderS1 is kept', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            contains(ausbilder),
          );
        });
      });
    });

    group(
        'Given a Qualifications object with Ausbildungsassistent and AusbilderS2',
        () {
      final assistent = Assistent(null);
      final ausbilder = AusbilderS2(null);
      final qualifications = Qualifications(
        qualifications: [assistent, ausbilder],
      );
      group('When getOnlyHighestQualifications is called', () {
        test('Then Ausbildungsassistent is removed', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            isNot(contains(assistent)),
          );
        });
      });
    });

    group(
        'Given a Qualifications object with Ausbildungsassistent and AusbilderR1',
        () {
      final assistent = Assistent(null);
      final ausbilder = AusbilderR1(null);
      final qualifications = Qualifications(
        qualifications: [assistent, ausbilder],
      );
      group('When getOnlyHighestQualifications is called', () {
        test('Then Ausbildungsassistent is removed', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            isNot(contains(assistent)),
          );
        });
      });
    });

    group(
        'Given a Qualifications object with Ausbildungsassistent and AusbilderR2',
        () {
      final assistent = Assistent(null);
      final ausbilder = AusbilderR2(null);
      final qualifications = Qualifications(
        qualifications: [assistent, ausbilder],
      );
      group('When getOnlyHighestQualifications is called', () {
        test('Then Ausbildungsassistent is removed', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            isNot(contains(assistent)),
          );
        });
      });
    });

    group(
        'Given a Qualifications object with RSiWRD and San without Wasserretter',
        () {
      final rsiwrdQ = RSiWRD(null);
      final sanQ = San(null);
      final qualifications = Qualifications(
        qualifications: [rsiwrdQ, sanQ],
      );
      group('When getOnlyHighestQualifications is called', () {
        test('Then RSiWRD is kept', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            contains(rsiwrdQ),
          );
        });
        test('Then San is kept', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            contains(sanQ),
          );
        });
      });
    });

    group('Given a Qualifications object with RSiWRD, San and Wasserretter',
        () {
      final rsiwrdQ = RSiWRD(null);
      final sanQ = San(null);
      final wasserretterQ = Wasserretter(null);
      final qualifications = Qualifications(
        qualifications: [rsiwrdQ, sanQ, wasserretterQ],
      );
      group('When getOnlyHighestQualifications is called', () {
        test('Then RSiWRD is removed', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            isNot(contains(rsiwrdQ)),
          );
        });
        test('Then San is removed', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            isNot(contains(sanQ)),
          );
        });
        test('Then Wasserretter is kept', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            contains(wasserretterQ),
          );
        });
      });
    });

    group(
        'Given a Qualifications object with unrelated qualifications like Gold and Pirat',
        () {
      final goldQ = Gold(null);
      final piratQ = Pirat(null);
      final qualifications = Qualifications(
        qualifications: [goldQ, piratQ],
      );
      group('When getOnlyHighestQualifications is called', () {
        test('Then all qualifications are kept', () {
          expect(
            qualifications.getOnlyHighestQualifications(),
            containsAll([goldQ, piratQ]),
          );
        });
      });
    });
  });
}
