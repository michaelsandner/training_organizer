import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

void main() {
  group('Given qualification json', () {
    List<dynamic> json = [
      {'name': 'Pirat', 'date': '13.01.2000'},
      {'name': 'Bronze', 'date': '13.01.2001'},
      {'name': 'Silber', 'date': '13.01.2002'},
      {'name': 'Gold', 'date': '13.01.2003'},
      {'name': 'RettungsschwimmerBronze', 'date': '13.01.2004'},
      {'name': 'RettungsschwimmerSilber', 'date': '13.01.2005'},
      {'name': 'RettungsschwimmerGold', 'date': '13.01.2006'},
      {'name': 'RSiWRD', 'date': '13.01.2007'},
      {'name': 'San', 'date': '13.01.2008'},
      {'name': 'FachSan', 'date': '13.01.2009'},
      {'name': 'RettSan', 'date': '13.01.2010'},
      {'name': 'Wasserretter', 'date': '13.01.2011'},
      {'name': 'Ausbildungsassistent', 'date': '13.01.2012'},
      {'name': 'AusbilderS1', 'date': '13.01.2013'},
      {'name': 'AusbilderS2', 'date': '13.01.2014'},
      {'name': 'AusbilderR1', 'date': '13.01.2015'},
      {'name': 'AusbilderR2', 'date': '2000-10-10'},
      {'name': 'Gruppenleiter', 'date': null},
    ];

    group('When calling createQualifications', () {
      test('Then should return Qualifiactions', () {
        final qualificationsFactory = QualificationFactory();
        final qualifications = qualificationsFactory.createQualifications(json);

        expect(qualifications[0].name, 'Pirat');
        expect(qualifications[0].date!.year, 2000);
        expect(qualifications[1].name, 'Bronze');
        expect(qualifications[1].date!.year, 2001);
        expect(qualifications[2].name, 'Silber');
        expect(qualifications[2].date!.year, 2002);
        expect(qualifications[3].name, 'Gold');
        expect(qualifications[3].date!.year, 2003);
        expect(qualifications[4].name, 'RettungsschwimmerBronze');
        expect(qualifications[4].date!.year, 2004);
        expect(qualifications[5].name, 'RettungsschwimmerSilber');
        expect(qualifications[5].date!.year, 2005);
        expect(qualifications[6].name, 'RettungsschwimmerGold');
        expect(qualifications[6].date!.year, 2006);
        expect(qualifications[7].name, 'RSiWRD');
        expect(qualifications[7].date!.year, 2007);
        expect(qualifications[8].name, 'San');
        expect(qualifications[8].date!.year, 2008);
        expect(qualifications[9].name, 'FachSan');
        expect(qualifications[9].date!.year, 2009);
        expect(qualifications[10].name, 'RettSan');
        expect(qualifications[10].date!.year, 2010);
        expect(qualifications[11].name, 'Wasserretter');
        expect(qualifications[11].date!.year, 2011);
        expect(qualifications[12].name, 'Ausbildungsassistent');
        expect(qualifications[12].date!.year, 2012);
        expect(qualifications[13].name, 'AusbilderS1');
        expect(qualifications[13].date!.year, 2013);
        expect(qualifications[14].name, 'AusbilderS2');
        expect(qualifications[14].date!.year, 2014);
        expect(qualifications[15].name, 'AusbilderR1');
        expect(qualifications[15].date!.year, 2015);
        expect(qualifications[16].name, 'AusbilderR2');
        expect(qualifications[16].date, null);
        expect(qualifications[17].name, 'Gruppenleiter');
        expect(qualifications[17].date, null);
      });
    });
  });
}
