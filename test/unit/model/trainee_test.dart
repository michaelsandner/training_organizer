import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/qualifications.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/silber.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  group('Given fields have values', () {
    group('When fromJson is called', () {
      test('Then each value should be set', () {
        final inputJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'dateOfBirth': '2000-05-01',
          'trainingGroup': 'groupA',
          'phone': '000111',
          'comment': 'this is a comment',
          'isMember': true,
          'isTrainer': true,
          'qualification': null,
          'qualifications': [
            {'name': 'RettungsschwimmerBronze', 'date': '09.09.2020'},
            {'name': 'RettungsschwimmerSilber', 'date': '09.09.2020'},
            {'name': 'Ausbildungsassistent', 'date': '09.09.2020'},
            {'name': 'San', 'date': '09.09.2020'},
            {'name': 'FachSan', 'date': '09.09.2020'},
            {'name': 'RettSan', 'date': '09.09.2020'},
          ]
        };

        final output = Trainee.fromJson(inputJson);

        expect(output.dateOfBirth, '2000-05-01');
        expect(output.surname, 'Mustermann');
        expect(output.forename, 'Max');
        expect(output.email, 'email@web.de');
        expect(output.phone, '000111');
        expect(output.comment, 'this is a comment');
        expect(output.isMember, true);
        expect(output.isTrainer, true);

        expect(output.qualifications.qualifications[0].name,
            'RettungsschwimmerBronze');
        expect(output.qualifications.qualifications[1].name,
            'RettungsschwimmerSilber');
        expect(output.qualifications.qualifications[2].name,
            'Ausbildungsassistent');
        expect(output.qualifications.qualifications[3].name, 'San');
        expect(output.qualifications.qualifications[4].name, 'FachSan');
        expect(output.qualifications.qualifications[5].name, 'RettSan');

        expect(
            output.qualifications.qualifications[0].date, DateTime(2020, 9, 9));
      });
    });

    group('When toJson is called', () {
      test('Then each value should be set', () {
        final input = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@web.de',
          phone: '000111',
          dateOfBirth: '2000-05-01',
          registrationDate: '01.01.2023',
          trainingGroup: Group.group1,
          comment: 'this is a comment',
          isMember: true,
          isTrainer: true,
          qualifications:
              Qualifications(qualifications: [Silber(null), Gold(null)]),
        );

        final expectedJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'phone': '000111',
          'dateOfBirth': '2000-05-01',
          'registrationDate': '01.01.2023',
          'trainingGroup': 'group1',
          'comment': 'this is a comment',
          'isMember': true,
          'isTrainer': true,
          'qualifications': [
            {'name': 'Silber', 'date': null},
            {'name': 'Gold', 'date': null}
          ]
        };

        final output = input.toJson();

        expect(output, expectedJson);
      });
    });
  });

  group('Given field do not have values', () {
    group('When fromJson is called', () {
      test('Then each value should be a default value', () {
        final inputJson = {
          'surname': null,
          'forename': null,
          'email': null,
          'dateOfBirth': null,
          'trainingGroup': null,
          'phone': null,
          'comment': null,
          'isMember': null,
          'isTrainer': null,
          'qualification': null,
          'qualifications': null,
        };

        final output = Trainee.fromJson(inputJson);

        expect(output.dateOfBirth, '');
        expect(output.surname, '');
        expect(output.forename, '');
        expect(output.email, '');
        expect(output.phone, '');
        expect(output.comment, '');
        expect(output.isMember, false);
        expect(output.isTrainer, false);
        expect(output.trainingGroup, Group.waitingList);
        expect(output.qualifications.qualifications.isEmpty, true);
      });
    });

    group('When toJson is called', () {
      test('Then each value should be set', () {
        final input = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@web.de',
          phone: '000111',
          dateOfBirth: '2000-05-01',
          registrationDate: '01.01.2023',
          trainingGroup: Group.group1,
          comment: 'this is a comment',
          isMember: false,
          isTrainer: false,
          qualifications: const Qualifications(),
        );

        final expectedJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'phone': '000111',
          'dateOfBirth': '2000-05-01',
          'registrationDate': '01.01.2023',
          'trainingGroup': 'group1',
          'comment': 'this is a comment',
          'isMember': false,
          'isTrainer': false,
          'qualifications': []
        };

        final output = input.toJson();

        expect(output, expectedJson);
      });
    });
  });
}
