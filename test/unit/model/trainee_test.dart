import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/qualification.dart';
import 'package:training_organizer/model/qualification_type.dart';
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
          'qualification': {
            'name': 'Bronze',
            'date': '2020-09-09 00:00:00.000'
          },
          'qualifications': [
            {'name': 'RettungsschwimmerSilber', 'date': '09.09.2020'},
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
        expect(output.qualification!.qualificationType.name, 'Bronze');
        expect(output.isTrainer, true);
        expect(output.qualifications.length, 1);
        expect(output.qualifications[0]!.qualificationType.name,
            'RettungsschwimmerSilber');
        expect(output.qualifications[0]!.date, DateTime(2020, 9, 9));
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
          qualification: Qualification(
              qualificationType: QualificationType.bronze, date: null),
          qualifications: [
            Qualification(
                qualificationType: QualificationType.silber, date: null),
            Qualification(qualificationType: QualificationType.gold, date: null)
          ],
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
          'qualification': {'name': 'Bronze', 'date': null},
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
        expect(output.qualification, null);
        expect(output.trainingGroup, Group.waitingList);
        expect(output.qualifications.isEmpty, true);
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
          qualification: null,
          qualifications: [null, null],
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
          'qualification': null,
          'qualifications': []
        };

        final output = input.toJson();

        expect(output, expectedJson);
      });
    });
  });
}
