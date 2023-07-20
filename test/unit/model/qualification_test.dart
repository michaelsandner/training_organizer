import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/model/qualification.dart';
import 'package:training_organizer/model/qualification_type.dart';

void main() {
  final qualificationFactory = QualificationFactory();
  group('qualification', () {
    group('Given pirate', () {
      test('Then type should be pirate', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.pirate);

        expect(piratequalification.qualificationType, QualificationType.pirate);
        expect(piratequalification.qualificationType.name, 'Pirat');
        expect(piratequalification.qualificationType.shortName, 'Seeräuber');
        expect(piratequalification.qualificationType.fullName, 'Seeräuber');
      });
    });

    group('Given bronze', () {
      test('Then type should be bronze', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.bronze);

        expect(piratequalification.qualificationType, QualificationType.bronze);
        expect(piratequalification.qualificationType.name, 'Bronze');
        expect(piratequalification.qualificationType.shortName, 'Bronze');
        expect(piratequalification.qualificationType.fullName,
            'Schwimmabzeichen Bronze');
      });
    });

    group('Given silber', () {
      test('Then type should be silber', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.silber);

        expect(piratequalification.qualificationType, QualificationType.silber);
        expect(piratequalification.qualificationType.name, 'Silber');
        expect(piratequalification.qualificationType.shortName, 'Silber');
        expect(piratequalification.qualificationType.fullName,
            'Schwimmabzeichen Silber');
      });
    });

    group('Given gold', () {
      test('Then type should be gold', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.gold);

        expect(piratequalification.qualificationType, QualificationType.gold);
        expect(piratequalification.qualificationType.name, 'Gold');
        expect(piratequalification.qualificationType.shortName, 'Gold');
        expect(piratequalification.qualificationType.fullName,
            'Schwimmabzeichen Gold');
      });
    });

    group('Given rettungsschwimmer bronze', () {
      test('Then type should be rettungsschwimmer bronze', () {
        final piratequalification = Qualification(
            qualificationType: QualificationType.rettungschwimmerBronze);

        expect(piratequalification.qualificationType,
            QualificationType.rettungschwimmerBronze);
        expect(piratequalification.qualificationType.name,
            'RettungsschwimmerBronze');
        expect(piratequalification.qualificationType.shortName, 'RS Bronze');
        expect(piratequalification.qualificationType.fullName,
            'Rettungsschwimmabzeichen Bronze');
      });
    });

    group('Given rettungsschwimmer silber', () {
      test('Then type shouldd be rettungsschwimmer silber', () {
        final piratequalification = Qualification(
            qualificationType: QualificationType.rettungsschwimmerSilber);

        expect(piratequalification.qualificationType,
            QualificationType.rettungsschwimmerSilber);
        expect(piratequalification.qualificationType.name,
            'RettungsschwimmerSilber');
        expect(piratequalification.qualificationType.shortName,
            'RS Silber (< 2 Jahre)');
        expect(piratequalification.qualificationType.fullName,
            'Rettungsschwimmabzeichen Silber');
      });
    });

    group('Given rettungsschwimmer gold', () {
      test('Then type should be rettungsschwimmer gold', () {
        final piratequalification = Qualification(
            qualificationType: QualificationType.rettungsschwimmerGold);

        expect(piratequalification.qualificationType,
            QualificationType.rettungsschwimmerGold);
        expect(piratequalification.qualificationType.name,
            'RettungsschwimmerGold');
        expect(piratequalification.qualificationType.shortName, 'RS Gold');
        expect(piratequalification.qualificationType.fullName,
            'Rettungsschwimmabzeichen Gold');
      });
    });

    group('Given rettungsschwimmer im Wasserrettungsdienst', () {
      test('Then type should be rettungsschwimmer im Wasserrettungsdienst', () {
        final piratequalification = Qualification(
            qualificationType:
                QualificationType.rettungsschwimmerImWasserrettungsdienst);

        expect(piratequalification.qualificationType,
            QualificationType.rettungsschwimmerImWasserrettungsdienst);
        expect(piratequalification.qualificationType.name, 'RSiWRD');
        expect(piratequalification.qualificationType.shortName, 'RSiWRD');
        expect(piratequalification.qualificationType.fullName,
            'Rettungsschwimmer im Wasserrettungsdient');
      });
    });

    group('Given san', () {
      test('Then type should be san', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.san);

        expect(piratequalification.qualificationType, QualificationType.san);
        expect(piratequalification.qualificationType.name, 'San');
        expect(piratequalification.qualificationType.shortName, 'San');
        expect(piratequalification.qualificationType.fullName,
            'Sanitätsdiensthelfer');
      });
    });

    group('Given wasserretter', () {
      test('Then type should be wasserretter', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.wassserretter);

        expect(piratequalification.qualificationType,
            QualificationType.wassserretter);
        expect(piratequalification.qualificationType.name, 'Wasserretter');
        expect(piratequalification.qualificationType.shortName, 'Wasserretter');
        expect(piratequalification.qualificationType.fullName, 'Wasserretter');
      });
    });

    group('Given ausbildungsassistent', () {
      test('Then type should be ausbildungsassistent', () {
        final piratequalification = Qualification(
            qualificationType: QualificationType.ausbildungsassistent);

        expect(piratequalification.qualificationType,
            QualificationType.ausbildungsassistent);
        expect(
            piratequalification.qualificationType.name, 'Ausbildungsassistent');
        expect(piratequalification.qualificationType.shortName, 'Assistent');
        expect(piratequalification.qualificationType.fullName,
            'Ausbildungsassistent');
      });
    });

    group('Given ausbilder s1', () {
      test('Then type should be s1', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.ausbilderS1);

        expect(piratequalification.qualificationType,
            QualificationType.ausbilderS1);
        expect(piratequalification.qualificationType.name, 'AusbilderS1');
        expect(piratequalification.qualificationType.shortName, 'AusbilderS1');
        expect(piratequalification.qualificationType.fullName,
            'Ausbilder S Stufe 1');
      });
    });

    group('Given ausbilder s2', () {
      test('Then type should be s2', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.ausbilderS2);

        expect(piratequalification.qualificationType,
            QualificationType.ausbilderS2);
        expect(piratequalification.qualificationType.name, 'AusbilderS2');
        expect(piratequalification.qualificationType.shortName, 'AusbilderS2');
        expect(piratequalification.qualificationType.fullName,
            'Ausbilder S Stufe 2');
      });
    });

    group('Given ausbilder r1', () {
      test('Then type should be r1', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.ausbilderR1);

        expect(piratequalification.qualificationType,
            QualificationType.ausbilderR1);
        expect(piratequalification.qualificationType.name, 'AusbilderR1');
        expect(piratequalification.qualificationType.shortName, 'AusbilderR1');
        expect(piratequalification.qualificationType.fullName,
            'Ausbilder R Stufe 1');
      });
    });

    group('Given ausbilder r2', () {
      test('Then type should be r2', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.ausbilderR2);

        expect(piratequalification.qualificationType,
            QualificationType.ausbilderR2);
        expect(piratequalification.qualificationType.name, 'AusbilderR2');
        expect(piratequalification.qualificationType.shortName, 'AusbilderR2');
        expect(piratequalification.qualificationType.fullName,
            'Ausbilder R Stufe 2');
      });
    });

    group('Given gruppenleiter', () {
      test('Then type should be gruppenleiter', () {
        final piratequalification =
            Qualification(qualificationType: QualificationType.gruppenleiter);

        expect(piratequalification.qualificationType,
            QualificationType.gruppenleiter);
        expect(piratequalification.qualificationType.name, 'Gruppenleiter');
        expect(
            piratequalification.qualificationType.shortName, 'Gruppenleiter');
        expect(piratequalification.qualificationType.fullName, 'Gruppenleiter');
      });
    });

    group('toJson', () {
      group('when date is null', () {
        test('shouldd store null', () {
          final bronzequalification = Qualification(
              qualificationType: QualificationType.bronze, date: null);
          final expectedJson = {
            'name': 'Bronze',
            'date': null,
          };

          expect(bronzequalification.toJson(), expectedJson);
        });
      });

      group('when date is valid', () {
        test('shouldd store date', () {
          final bronzequalification = Qualification(
              qualificationType: QualificationType.bronze,
              date: DateTime(2020, 9, 9));

          final expectedJson = {
            'name': 'Bronze',
            'date': '09.09.2020',
          };

          expect(bronzequalification.toJson(), expectedJson);
        });
      });
    });

    group('Given date is not null', () {
      group('When fromJson is called', () {
        test('shouldd parse date', () {
          final inputJson = {
            'name': 'Bronze',
            'date': '09.09.2020',
          };

          final qualification =
              qualificationFactory.getQualification(inputJson);

          expect(qualification!.qualificationType.name, 'Bronze');
          expect(qualification.date, (DateTime(2020, 9, 9)));
        });
      });
    });

    group('Given date has wrong format', () {
      group('When fromJson is called', () {
        test('shouldd set null', () {
          final inputJson = {
            'name': 'Bronze',
            'date': '2000-10-10',
          };

          final qualification =
              qualificationFactory.getQualification(inputJson);

          expect(qualification!.qualificationType.name, 'Bronze');
          expect(qualification.date, null);
        });
      });
    });

    group('Given date is null', () {
      group('When fromJson is called', () {
        test('shouldd set null', () {
          final inputJson = {
            'name': 'Bronze',
            'date': null,
          };

          final qualification =
              qualificationFactory.getQualification(inputJson);

          expect(qualification!.qualificationType.name, 'Bronze');
          expect(qualification.date, null);
        });
      });
    });

    group('Given is older than two years isUpToDate', () {
      group('When isUpToDate is called', () {
        test('Then shouldd returns false', () {
          final date = DateTime(DateTime.now().year - 2, DateTime.now().month,
              DateTime.now().day - 2);
          final bronzequalification = Qualification(
              qualificationType: QualificationType.bronze, date: date);

          expect(bronzequalification.isUpToDate, false);
        });
      });
    });
    group('Given is younger than two years', () {
      group('When isUpToDate is called', () {
        test('returns true', () {
          final date = DateTime(DateTime.now().year - 2, DateTime.now().month,
              DateTime.now().day + 1);
          final bronzequalification = Qualification(
              qualificationType: QualificationType.bronze, date: date);

          expect(bronzequalification.isUpToDate, true);
        });
      });
    });
  });
}
