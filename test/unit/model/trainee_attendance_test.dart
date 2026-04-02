import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  group('Trainee attendance dates', () {
    group('Given attendance dates in JSON', () {
      group('When fromJson is called', () {
        test('Then attendance dates should be parsed', () {
          final inputJson = {
            'surname': 'Mustermann',
            'forename': 'Max',
            'email': 'email@web.de',
            'dateOfBirth': '2000-05-01',
            'trainingGroup': 'group1',
            'phone': '000111',
            'comment': '',
            'isMember': false,
            'isTrainer': false,
            'qualifications': null,
            'attendanceDates': ['2024-01-13', '2024-01-17', '2024-01-20'],
          };

          final output = Trainee.fromJson(inputJson);

          expect(output.attendanceDates.length, 3);
          expect(output.attendanceDates[0], DateTime(2024, 1, 13));
          expect(output.attendanceDates[1], DateTime(2024, 1, 17));
          expect(output.attendanceDates[2], DateTime(2024, 1, 20));
        });
      });
    });

    group('Given no attendance dates in JSON', () {
      group('When fromJson is called', () {
        test('Then attendance dates should be empty', () {
          final inputJson = {
            'surname': 'Mustermann',
            'forename': 'Max',
            'email': 'email@web.de',
            'dateOfBirth': '2000-05-01',
            'trainingGroup': 'group1',
            'phone': '000111',
            'comment': '',
            'isMember': false,
            'isTrainer': false,
            'qualifications': null,
          };

          final output = Trainee.fromJson(inputJson);

          expect(output.attendanceDates.isEmpty, true);
        });
      });
    });

    group('Given null attendance dates in JSON', () {
      group('When fromJson is called', () {
        test('Then attendance dates should be empty', () {
          final inputJson = {
            'surname': 'Mustermann',
            'forename': 'Max',
            'email': 'email@web.de',
            'dateOfBirth': '2000-05-01',
            'trainingGroup': 'group1',
            'phone': '000111',
            'comment': '',
            'isMember': false,
            'isTrainer': false,
            'qualifications': null,
            'attendanceDates': null,
          };

          final output = Trainee.fromJson(inputJson);

          expect(output.attendanceDates.isEmpty, true);
        });
      });
    });

    group('Given attendance dates in German format', () {
      group('When fromJson is called', () {
        test('Then attendance dates should be parsed', () {
          final inputJson = {
            'surname': 'Mustermann',
            'forename': 'Max',
            'email': 'email@web.de',
            'dateOfBirth': '2000-05-01',
            'trainingGroup': 'group1',
            'phone': '000111',
            'comment': '',
            'isMember': false,
            'isTrainer': false,
            'qualifications': null,
            'attendanceDates': ['13.01.2024', '17.01.2024'],
          };

          final output = Trainee.fromJson(inputJson);

          expect(output.attendanceDates.length, 2);
          expect(output.attendanceDates[0].year, 2024);
          expect(output.attendanceDates[0].month, 1);
          expect(output.attendanceDates[0].day, 13);
          expect(output.attendanceDates[1].day, 17);
        });
      });
    });

    group('Given invalid attendance dates in JSON', () {
      group('When fromJson is called', () {
        test('Then invalid dates should be skipped', () {
          final inputJson = {
            'surname': 'Mustermann',
            'forename': 'Max',
            'email': 'email@web.de',
            'dateOfBirth': '2000-05-01',
            'trainingGroup': 'group1',
            'phone': '000111',
            'comment': '',
            'isMember': false,
            'isTrainer': false,
            'qualifications': null,
            'attendanceDates': ['2024-01-13', 'invalid-date', '2024-01-20'],
          };

          final output = Trainee.fromJson(inputJson);

          expect(output.attendanceDates.length, 2);
          expect(output.attendanceDates[0].day, 13);
          expect(output.attendanceDates[1].day, 20);
        });
      });
    });

    group('Given trainee with attendance dates', () {
      group('When toJson is called', () {
        test('Then attendance dates should be serialized', () {
          final input = Trainee(
            surname: 'Mustermann',
            forename: 'Max',
            email: 'email@web.de',
            phone: '000111',
            dateOfBirth: '2000-05-01',
            registrationDate: '01.01.2023',
            trainingGroup: Group.group1,
            comment: '',
            isMember: false,
            isTrainer: false,
            attendanceDates: [
              DateTime(2024, 1, 13),
              DateTime(2024, 1, 17),
            ],
          );

          final output = input.toJson();

          expect(output['attendanceDates'], ['2024-01-13', '2024-01-17']);
        });
      });
    });

    group('Given trainee without attendance dates', () {
      group('When toJson is called', () {
        test('Then attendance dates should be empty list', () {
          final input = Trainee(
            surname: 'Mustermann',
            forename: 'Max',
            email: 'email@web.de',
            phone: '000111',
            dateOfBirth: '2000-05-01',
            registrationDate: '01.01.2023',
            trainingGroup: Group.group1,
            comment: '',
            isMember: false,
            isTrainer: false,
          );

          final output = input.toJson();

          expect(output['attendanceDates'], []);
        });
      });
    });

    group('Given trainee with attendance dates', () {
      group('When copyWith is called with new dates', () {
        test('Then attendance dates should be updated', () {
          final trainee = Trainee(
            surname: 'Mustermann',
            forename: 'Max',
            attendanceDates: [DateTime(2024, 1, 13)],
          );

          final updated = trainee.copyWith(
            attendanceDates: [DateTime(2024, 1, 13), DateTime(2024, 1, 17)],
          );

          expect(updated.attendanceDates.length, 2);
          expect(updated.surname, 'Mustermann');
        });
      });

      group('When copyWithNewGroup is called', () {
        test('Then attendance dates should be preserved', () {
          final trainee = Trainee(
            surname: 'Mustermann',
            forename: 'Max',
            trainingGroup: Group.group1,
            attendanceDates: [DateTime(2024, 1, 13)],
          );

          final updated = trainee.copyWithNewGroup(Group.group2);

          expect(updated.attendanceDates.length, 1);
          expect(updated.trainingGroup, Group.group2);
        });
      });
    });
  });
}
