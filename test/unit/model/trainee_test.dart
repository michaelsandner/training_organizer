import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  group('fromJson', () {
    group('Given each field has a value', () {
      test('Then each value should be set', () {
        final inputJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'dateOfBirth': '2000-05-01',
          'trainingGroup': 'groupA',
          'phone': '000111'
        };

        final output = Trainee.fromJson(inputJson);

        expect(output.dateOfBirth, '2000-05-01');
        expect(output.surname, 'Mustermann');
        expect(output.forename, 'Max');
        expect(output.email, 'email@web.de');
        expect(output.phone, '000111');
      });
    });

    group('Given group are null', () {
      test('Then dateOfBirth and group should be null', () {
        final inputJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'dateOfBirth': '',
          'phone': '',
          'trainingGroup': null
        };

        final output = Trainee.fromJson(inputJson);

        expect(output.dateOfBirth, '');
        expect(output.trainingGroup, null);
        expect(output.surname, 'Mustermann');
        expect(output.forename, 'Max');
        expect(output.email, 'email@web.de');
        expect(output.phone, '');
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
          trainingGroup: Group.group1,
        );

        final expectedJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'phone': '000111',
          'dateOfBirth': '2000-05-01',
          'trainingGroup': 'group1'
        };

        final output = input.toJson();

        expect(output, expectedJson);
      });
    });

    group('Given group are null', () {
      test('Then dateOfBirth and group should be null', () {
        final input = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@web.de',
          phone: '000111',
          dateOfBirth: '',
          trainingGroup: null,
        );

        final expectedJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'phone': '000111',
          'dateOfBirth': '',
          'trainingGroup': null
        };

        final output = input.toJson();

        expect(output, expectedJson);
      });
    });
  });
}
