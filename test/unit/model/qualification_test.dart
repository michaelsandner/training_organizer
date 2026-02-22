import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/model/qualifications/assitent.dart';
import 'package:training_organizer/model/qualifications/ausbilder_r1.dart';
import 'package:training_organizer/model/qualifications/ausbilder_r2.dart';
import 'package:training_organizer/model/qualifications/ausbilder_s1.dart';
import 'package:training_organizer/model/qualifications/ausbilder_s2.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/gruppenleiter.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/rs_bronze.dart';
import 'package:training_organizer/model/qualifications/rs_gold.dart';
import 'package:training_organizer/model/qualifications/rs_silber.dart';
import 'package:training_organizer/model/qualifications/rsiwrd.dart';
import 'package:training_organizer/model/qualifications/san.dart';
import 'package:training_organizer/model/qualifications/silber.dart';
import 'package:training_organizer/model/qualifications/wasserretter.dart';

void main() {
  group('qualification', () {
    group('Given pirate', () {
      group('When the qualification is created', () {
        test('Then type should be pirate', () {
          final piratequalification = Pirat(null);

          expect(piratequalification.name, 'Pirat');
          expect(piratequalification.shortName, 'Seeräuber');
          expect(piratequalification.fullName, 'Seeräuber');
        });
      });
    });

    group('Given bronze', () {
      group('When the qualification is created', () {
        test('Then type should be bronze', () {
          final piratequalification = Bronze(null);

          expect(piratequalification.name, 'Bronze');
          expect(piratequalification.shortName, 'Bronze');
          expect(piratequalification.fullName, 'Schwimmabzeichen Bronze');
        });
      });
    });

    group('Given silber', () {
      group('When the qualification is created', () {
        test('Then type should be silber', () {
          final piratequalification = Silber(null);

          expect(piratequalification.name, 'Silber');
          expect(piratequalification.shortName, 'Silber');
          expect(piratequalification.fullName, 'Schwimmabzeichen Silber');
        });
      });
    });

    group('Given gold', () {
      group('When the qualification is created', () {
        test('Then type should be gold', () {
          final piratequalification = Gold(null);

          expect(piratequalification.name, 'Gold');
          expect(piratequalification.shortName, 'Gold');
          expect(piratequalification.fullName, 'Schwimmabzeichen Gold');
        });
      });
    });

    group('Given rettungsschwimmer bronze', () {
      group('When the qualification is created', () {
        test('Then type should be rettungsschwimmer bronze', () {
          final piratequalification = RsBronze(null);

          expect(piratequalification.name, 'RettungsschwimmerBronze');
          expect(piratequalification.shortName, 'RS Bronze');
          expect(
              piratequalification.fullName, 'Rettungsschwimmabzeichen Bronze');
        });
      });
    });

    group('Given rettungsschwimmer silber', () {
      group('When the qualification is created', () {
        test('Then type should be rettungsschwimmer silber', () {
          final piratequalification = RsSilber(null);

          expect(piratequalification.name, 'RettungsschwimmerSilber');
          expect(piratequalification.shortName, 'RS Silber (< 2 Jahre)');
          expect(
              piratequalification.fullName, 'Rettungsschwimmabzeichen Silber');
        });
      });
    });

    group('Given rettungsschwimmer gold', () {
      group('When the qualification is created', () {
        test('Then type should be rettungsschwimmer gold', () {
          final piratequalification = RsGold(null);

          expect(piratequalification.name, 'RettungsschwimmerGold');
          expect(piratequalification.shortName, 'RS Gold');
          expect(piratequalification.fullName, 'Rettungsschwimmabzeichen Gold');
        });
      });
    });

    group('Given rettungsschwimmer im Wasserrettungsdienst', () {
      group('When the qualification is created', () {
        test('Then type should be rettungsschwimmer im Wasserrettungsdienst',
            () {
          final piratequalification = RSiWRD(null);

          expect(piratequalification.name, 'RSiWRD');
          expect(piratequalification.shortName, 'RSiWRD');
          expect(piratequalification.fullName,
              'Rettungsschwimmer*in im Wasserrettungsdient');
        });
      });
    });

    group('Given san', () {
      group('When the qualification is created', () {
        test('Then type should be san', () {
          final piratequalification = San(null);

          expect(piratequalification.name, 'San');
          expect(piratequalification.shortName, 'San');
          expect(piratequalification.fullName, 'Sanitätsdiensthelfer*in');
        });
      });
    });

    group('Given wasserretter', () {
      group('When the qualification is created', () {
        test('Then type should be wasserretter', () {
          final piratequalification = Wasserretter(null);

          expect(piratequalification.name, 'Wasserretter');
          expect(piratequalification.shortName, 'Wasserretter');
          expect(piratequalification.fullName, 'Wasserretter*in');
        });
      });
    });

    group('Given ausbildungsassistent', () {
      group('When the qualification is created', () {
        test('Then type should be ausbildungsassistent', () {
          final piratequalification = Assistent(null);

          expect(piratequalification.name, 'Ausbildungsassistent');
          expect(piratequalification.shortName, 'Assistent');
          expect(piratequalification.fullName, 'Ausbildungsassistent*in');
        });
      });
    });

    group('Given ausbilder s1', () {
      group('When the qualification is created', () {
        test('Then type should be s1', () {
          final piratequalification = AusbilderS1(null);

          expect(piratequalification.name, 'AusbilderS1');
          expect(piratequalification.shortName, 'AusbilderS1');
          expect(piratequalification.fullName, 'Ausbilder*in S Stufe 1');
        });
      });
    });

    group('Given ausbilder s2', () {
      group('When the qualification is created', () {
        test('Then type should be s2', () {
          final piratequalification = AusbilderS2(null);

          expect(piratequalification.name, 'AusbilderS2');
          expect(piratequalification.shortName, 'AusbilderS2');
          expect(piratequalification.fullName, 'Ausbilder*in S Stufe 2');
        });
      });
    });

    group('Given ausbilder r1', () {
      group('When the qualification is created', () {
        test('Then type should be r1', () {
          final piratequalification = AusbilderR1(null);

          expect(piratequalification.name, 'AusbilderR1');
          expect(piratequalification.shortName, 'AusbilderR1');
          expect(piratequalification.fullName, 'Ausbilder*in R Stufe 1');
        });
      });
    });

    group('Given ausbilder r2', () {
      group('When the qualification is created', () {
        test('Then type should be r2', () {
          final piratequalification = AusbilderR2(null);

          expect(piratequalification.name, 'AusbilderR2');
          expect(piratequalification.shortName, 'AusbilderR2');
          expect(piratequalification.fullName, 'Ausbilder*in R Stufe 2');
        });
      });
    });

    group('Given gruppenleiter', () {
      group('When the qualification is created', () {
        test('Then type should be gruppenleiter', () {
          final piratequalification = Gruppenleiter(null);

          expect(piratequalification.name, 'Gruppenleiter');
          expect(piratequalification.shortName, 'Gruppenleiter');
          expect(piratequalification.fullName, 'Gruppenleiter*in');
        });
      });
    });

    group('Given a Bronze qualification', () {
      group('When toJson is called with null date', () {
        test('Then it should store null', () {
          final bronzequalification = Bronze(null);
          final expectedJson = {
            'name': 'Bronze',
            'date': null,
          };

          expect(bronzequalification.toJson(), expectedJson);
        });
      });

      group('When toJson is called with valid date', () {
        test('Then it should store the date', () {
          final bronzequalification = Bronze(DateTime(2020, 9, 9));

          final expectedJson = {
            'name': 'Bronze',
            'date': '09.09.2020',
          };

          expect(bronzequalification.toJson(), expectedJson);
        });
      });
    });

    group('Given is older than two years isUpToDate', () {
      group('When isUpToDate is called', () {
        test('Then it should return false', () {
          final date = DateTime(DateTime.now().year - 2, DateTime.now().month,
              DateTime.now().day - 2);
          final rsSilber = RsSilber(date);

          expect(rsSilber.isUp2Date, false);
        });
      });
    });
    group('Given is younger than two years', () {
      group('When isUpToDate is called', () {
        test('Then it should return true', () {
          final date = DateTime(DateTime.now().year - 2, DateTime.now().month,
              DateTime.now().day + 1);
          final rsSilber = RsSilber(date);

          expect(rsSilber.isUp2Date, true);
        });
      });
    });
  });
}
