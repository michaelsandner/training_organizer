import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/trainee.dart';

void main() {
  group('fromJson', () {
    test('each value is set', () {
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

    test('dateOfBirth and group are null', () {
      final inputJson = {
        'surname': 'Mustermann',
        'forename': 'Max',
        'email': 'email@web.de',
        'dateOfBirth': null,
        'trainingGroup': null
      };

      final output = Trainee.fromJson(inputJson);

      expect(output.dateOfBirth, null);
      expect(output.surname, 'Mustermann');
      expect(output.forename, 'Max');
      expect(output.email, 'email@web.de');
      expect(output.trainingGroup, null);
    });
  });

  group('toJson', () {
    test('each value is set', () {
      final input = Trainee(
        surname: 'Mustermann',
        forename: 'Max',
        email: 'email@web.de',
        dateOfBirth: DateTime(2000, 5, 1),
        trainingGroup: 'groupA',
      );

      final expectedJson = {
        'surname': 'Mustermann',
        'forename': 'Max',
        'email': 'email@web.de',
        'dateOfBirth': '2000-05-01',
        'trainingGroup': 'groupA'
      };

      final output = input.toJson();

      expect(output, expectedJson);
    });

    test('dateOfBirth and group are null', () {
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
}
