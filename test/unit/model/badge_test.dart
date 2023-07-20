import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/model/badge.dart';

void main() {
  final badgeFactory = BadgeFactory();
  group('Badge', () {
    group('Given pirate', () {
      test('Then type should be pirate', () {
        final pirateBadge = Qualification(badgeType: BadgeType.pirate);

        expect(pirateBadge.badgeType, BadgeType.pirate);
        expect(pirateBadge.badgeType.name, 'Seeräuber');
        expect(pirateBadge.badgeType.shortName, 'Seeräuber');
        expect(pirateBadge.badgeType.fullName, 'Seeräuber');
      });
    });

    group('Given bronze', () {
      test('Then type should be bronze', () {
        final pirateBadge = Qualification(badgeType: BadgeType.bronze);

        expect(pirateBadge.badgeType, BadgeType.bronze);
        expect(pirateBadge.badgeType.name, 'Bronze');
        expect(pirateBadge.badgeType.shortName, 'Bronze');
        expect(pirateBadge.badgeType.fullName, 'Schwimmabzeichen Bronze');
      });
    });

    group('Given silber', () {
      test('Then type should be silber', () {
        final pirateBadge = Qualification(badgeType: BadgeType.silber);

        expect(pirateBadge.badgeType, BadgeType.silber);
        expect(pirateBadge.badgeType.name, 'Silber');
        expect(pirateBadge.badgeType.shortName, 'Silber');
        expect(pirateBadge.badgeType.fullName, 'Schwimmabzeichen Silber');
      });
    });

    group('Given gold', () {
      test('Then type should be gold', () {
        final pirateBadge = Qualification(badgeType: BadgeType.gold);

        expect(pirateBadge.badgeType, BadgeType.gold);
        expect(pirateBadge.badgeType.name, 'Gold');
        expect(pirateBadge.badgeType.shortName, 'Gold');
        expect(pirateBadge.badgeType.fullName, 'Schwimmabzeichen Gold');
      });
    });

    group('Given rettungsschwimmer bronze', () {
      test('Then type should be rettungsschwimmer bronze', () {
        final pirateBadge =
            Qualification(badgeType: BadgeType.rettungschwimmerBronze);

        expect(pirateBadge.badgeType, BadgeType.rettungschwimmerBronze);
        expect(pirateBadge.badgeType.name, 'RettungsschwimmerBronze');
        expect(pirateBadge.badgeType.shortName, 'RS Bronze');
        expect(
            pirateBadge.badgeType.fullName, 'Rettungsschwimmabzeichen Bronze');
      });
    });

    group('Given rettungsschwimmer silber', () {
      test('Then type shouldd be rettungsschwimmer silber', () {
        final pirateBadge =
            Qualification(badgeType: BadgeType.rettungsschwimmerSilber);

        expect(pirateBadge.badgeType, BadgeType.rettungsschwimmerSilber);
        expect(pirateBadge.badgeType.name, 'RettungsschwimmerSilber');
        expect(pirateBadge.badgeType.shortName, 'RS Silber (< 2 Jahre)');
        expect(
            pirateBadge.badgeType.fullName, 'Rettungsschwimmabzeichen Silber');
      });
    });

    group('Given rettungsschwimmer gold', () {
      test('Then type should be rettungsschwimmer gold', () {
        final pirateBadge =
            Qualification(badgeType: BadgeType.rettungsschwimmerGold);

        expect(pirateBadge.badgeType, BadgeType.rettungsschwimmerGold);
        expect(pirateBadge.badgeType.name, 'RettungsschwimmerGold');
        expect(pirateBadge.badgeType.shortName, 'RS Gold');
        expect(pirateBadge.badgeType.fullName, 'Rettungsschwimmabzeichen Gold');
      });
    });

    group('Given rettungsschwimmer im Wasserrettungsdienst', () {
      test('Then type should be rettungsschwimmer im Wasserrettungsdienst', () {
        final pirateBadge = Qualification(
            badgeType: BadgeType.rettungsschwimmerImWasserrettungsdienst);

        expect(pirateBadge.badgeType,
            BadgeType.rettungsschwimmerImWasserrettungsdienst);
        expect(pirateBadge.badgeType.name, 'RSiWRD');
        expect(pirateBadge.badgeType.shortName, 'RSiWRD');
        expect(pirateBadge.badgeType.fullName,
            'Rettungsschwimmer im Wasserrettungsdient');
      });
    });

    group('Given san', () {
      test('Then type should be san', () {
        final pirateBadge = Qualification(badgeType: BadgeType.san);

        expect(pirateBadge.badgeType, BadgeType.san);
        expect(pirateBadge.badgeType.name, 'San');
        expect(pirateBadge.badgeType.shortName, 'San');
        expect(pirateBadge.badgeType.fullName, 'Sanitätsdiensthelfer');
      });
    });

    group('Given wasserretter', () {
      test('Then type should be wasserretter', () {
        final pirateBadge = Qualification(badgeType: BadgeType.wassserretter);

        expect(pirateBadge.badgeType, BadgeType.wassserretter);
        expect(pirateBadge.badgeType.name, 'Wasserretter');
        expect(pirateBadge.badgeType.shortName, 'Wasserretter');
        expect(pirateBadge.badgeType.fullName, 'Wasserretter');
      });
    });

    group('Given ausbildungsassistent', () {
      test('Then type should be ausbildungsassistent', () {
        final pirateBadge =
            Qualification(badgeType: BadgeType.ausbildungsassistent);

        expect(pirateBadge.badgeType, BadgeType.ausbildungsassistent);
        expect(pirateBadge.badgeType.name, 'Ausbildungsassistent');
        expect(pirateBadge.badgeType.shortName, 'Assistent');
        expect(pirateBadge.badgeType.fullName, 'Ausbildungsassistent');
      });
    });

    group('Given ausbilder s1', () {
      test('Then type should be s1', () {
        final pirateBadge = Qualification(badgeType: BadgeType.ausbilderS1);

        expect(pirateBadge.badgeType, BadgeType.ausbilderS1);
        expect(pirateBadge.badgeType.name, 'AusbilderS1');
        expect(pirateBadge.badgeType.shortName, 'AusbilderS1');
        expect(pirateBadge.badgeType.fullName, 'Ausbilder S Stufe 1');
      });
    });

    group('Given ausbilder s2', () {
      test('Then type should be s2', () {
        final pirateBadge = Qualification(badgeType: BadgeType.ausbilderS2);

        expect(pirateBadge.badgeType, BadgeType.ausbilderS2);
        expect(pirateBadge.badgeType.name, 'AusbilderS2');
        expect(pirateBadge.badgeType.shortName, 'AusbilderS2');
        expect(pirateBadge.badgeType.fullName, 'Ausbilder S Stufe 2');
      });
    });

    group('Given ausbilder r1', () {
      test('Then type should be r1', () {
        final pirateBadge = Qualification(badgeType: BadgeType.ausbilderR1);

        expect(pirateBadge.badgeType, BadgeType.ausbilderR1);
        expect(pirateBadge.badgeType.name, 'AusbilderR1');
        expect(pirateBadge.badgeType.shortName, 'AusbilderR1');
        expect(pirateBadge.badgeType.fullName, 'Ausbilder R Stufe 1');
      });
    });

    group('Given ausbilder r2', () {
      test('Then type should be r2', () {
        final pirateBadge = Qualification(badgeType: BadgeType.ausbilderR2);

        expect(pirateBadge.badgeType, BadgeType.ausbilderR2);
        expect(pirateBadge.badgeType.name, 'AusbilderR2');
        expect(pirateBadge.badgeType.shortName, 'AusbilderR2');
        expect(pirateBadge.badgeType.fullName, 'Ausbilder R Stufe 2');
      });
    });

    group('Given gruppenleiter', () {
      test('Then type should be gruppenleiter', () {
        final pirateBadge = Qualification(badgeType: BadgeType.gruppenleiter);

        expect(pirateBadge.badgeType, BadgeType.gruppenleiter);
        expect(pirateBadge.badgeType.name, 'Gruppenleiter');
        expect(pirateBadge.badgeType.shortName, 'Gruppenleiter');
        expect(pirateBadge.badgeType.fullName, 'Gruppenleiter');
      });
    });

    group('toJson', () {
      group('when date is null', () {
        test('shouldd store null', () {
          final bronzeBadge =
              Qualification(badgeType: BadgeType.bronze, date: null);
          final expectedJson = {
            'name': 'Bronze',
            'date': null,
          };

          expect(bronzeBadge.toJson(), expectedJson);
        });
      });

      group('when date is valid', () {
        test('shouldd store date', () {
          final bronzeBadge = Qualification(
              badgeType: BadgeType.bronze, date: DateTime(2020, 9, 9));

          final expectedJson = {
            'name': 'Bronze',
            'date': '09.09.2020',
          };

          expect(bronzeBadge.toJson(), expectedJson);
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

          final badge = badgeFactory.getBadge(inputJson);

          expect(badge!.badgeType.name, 'Bronze');
          expect(badge.date, (DateTime(2020, 9, 9)));
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

          final badge = badgeFactory.getBadge(inputJson);

          expect(badge!.badgeType.name, 'Bronze');
          expect(badge.date, null);
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

          final badge = badgeFactory.getBadge(inputJson);

          expect(badge!.badgeType.name, 'Bronze');
          expect(badge.date, null);
        });
      });
    });

    group('Given is older than two years isUpToDate', () {
      group('When isUpToDate is called', () {
        test('Then shouldd returns false', () {
          final date = DateTime(DateTime.now().year - 2, DateTime.now().month,
              DateTime.now().day - 2);
          final bronzeBadge =
              Qualification(badgeType: BadgeType.bronze, date: date);

          expect(bronzeBadge.isUpToDate, false);
        });
      });
    });
    group('Given is younger than two years', () {
      group('When isUpToDate is called', () {
        test('returns true', () {
          final date = DateTime(DateTime.now().year - 2, DateTime.now().month,
              DateTime.now().day + 1);
          final bronzeBadge =
              Qualification(badgeType: BadgeType.bronze, date: date);

          expect(bronzeBadge.isUpToDate, true);
        });
      });
    });
  });
}
