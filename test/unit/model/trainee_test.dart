import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/badge.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  group('fromJson', () {
    group('Given fields have values', () {
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
          'badge': {'name': 'Bronze', 'date': '2020-09-09 00:00:00.000'},
        };

        final output = Trainee.fromJson(inputJson);

        expect(output.dateOfBirth, '2000-05-01');
        expect(output.surname, 'Mustermann');
        expect(output.forename, 'Max');
        expect(output.email, 'email@web.de');
        expect(output.phone, '000111');
        expect(output.comment, 'this is a comment');
        expect(output.isMember, true);
        expect(output.badge!.name, 'Bronze');
        expect(output.isTrainer, true);
        expect(output.badge!.date, DateTime(2020, 9, 9));
      });
    });

    group('Given field do not have values', () {
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
          'badge': null,
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
        expect(output.badge, null);
        expect(output.trainingGroup, Group.waitingList);
      });
    });
  });

  group('toJson', () {
    group('Given each filed has a valid value', () {
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
          badge: BronzeBadge(),
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
          'badge': {'name': 'Bronze', 'date': null},
        };

        final output = input.toJson();

        expect(output, expectedJson);
      });
    });
  });
}
