import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/app_state.dart';
import 'package:training_organizer/trainee.dart';

void main() {
  group('fromJson', () {
    group('Given each field has a value', () {
      test('Then each value should be set', () {
        final inputJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'dateOfBirth': '2000-05-01',
          'trainingGroup': 'groupA'
        };

        final output = Trainee.fromJson(inputJson);

        expect(output.dateOfBirth, DateTime(2000, 5, 1));
        expect(output.surname, 'Mustermann');
        expect(output.forename, 'Max');
        expect(output.email, 'email@web.de');
      });
    });

    group('Given dateOfBirth and group are null', () {
      test('Then dateOfBirth and group should be null', () {
        final inputJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'dateOfBirth': null,
          'trainingGroup': null
        };

        final output = Trainee.fromJson(inputJson);

        expect(output.dateOfBirth, null);
        expect(output.trainingGroup, null);
        expect(output.surname, 'Mustermann');
        expect(output.forename, 'Max');
        expect(output.email, 'email@web.de');
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
          dateOfBirth: DateTime(2000, 5, 1),
          trainingGroup: Group.group1,
        );

        final expectedJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'dateOfBirth': '2000-05-01',
          'trainingGroup': 'Group.group1'
        };

        final output = input.toJson();

        expect(output, expectedJson);
      });
    });

    group('Given dateOfBirth and group are null', () {
      test('Then dateOfBirth and group should be null', () {
        final input = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@web.de',
          dateOfBirth: null,
          trainingGroup: null,
        );

        final expectedJson = {
          'surname': 'Mustermann',
          'forename': 'Max',
          'email': 'email@web.de',
          'dateOfBirth': null,
          'trainingGroup': null
        };

        final output = input.toJson();

        expect(output, expectedJson);
      });
    });
  });
}
