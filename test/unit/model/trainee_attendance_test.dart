import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  group('Trainee attendance dates', () {
    group('Given attendance dates as flat list in JSON (legacy format)', () {
      group('When fromJson is called', () {
        test('Then attendance dates should be parsed under current group', () {
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

          expect(output.allAttendanceDates.length, 3);
          expect(output.attendanceDates.containsKey('group1'), true);
          expect(output.attendanceDates['group1']!.length, 3);
          expect(output.attendanceDates['group1']![0], DateTime(2024, 1, 13));
          expect(output.attendanceDates['group1']![1], DateTime(2024, 1, 17));
          expect(output.attendanceDates['group1']![2], DateTime(2024, 1, 20));
        });
      });
    });

    group('Given attendance dates as grouped map in JSON', () {
      group('When fromJson is called', () {
        test('Then attendance dates should be parsed per group', () {
          final inputJson = {
            'surname': 'Mustermann',
            'forename': 'Max',
            'email': 'email@web.de',
            'dateOfBirth': '2000-05-01',
            'trainingGroup': 'group2',
            'phone': '000111',
            'comment': '',
            'isMember': false,
            'isTrainer': false,
            'qualifications': null,
            'attendanceDates': {
              'group1': ['2024-01-13', '2024-01-20'],
              'group2': ['2024-03-16'],
            },
          };

          final output = Trainee.fromJson(inputJson);

          expect(output.attendanceDates.length, 2);
          expect(output.attendanceDates['group1']!.length, 2);
          expect(output.attendanceDates['group1']![0], DateTime(2024, 1, 13));
          expect(output.attendanceDates['group1']![1], DateTime(2024, 1, 20));
          expect(output.attendanceDates['group2']!.length, 1);
          expect(output.attendanceDates['group2']![0], DateTime(2024, 3, 16));
          expect(output.allAttendanceDates.length, 3);
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
          expect(output.allAttendanceDates.isEmpty, true);
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

    group('Given attendance dates in German format (legacy flat list)', () {
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

          final group1Dates = output.attendanceDates['group1']!;
          expect(group1Dates.length, 2);
          expect(group1Dates[0].year, 2024);
          expect(group1Dates[0].month, 1);
          expect(group1Dates[0].day, 13);
          expect(group1Dates[1].day, 17);
        });
      });
    });

    group('Given invalid attendance dates in JSON (legacy flat list)', () {
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

          final group1Dates = output.attendanceDates['group1']!;
          expect(group1Dates.length, 2);
          expect(group1Dates[0].day, 13);
          expect(group1Dates[1].day, 20);
        });
      });
    });

    group('Given invalid attendance dates in grouped format', () {
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
            'attendanceDates': {
              'group1': ['2024-01-13', 'invalid-date', '2024-01-20'],
            },
          };

          final output = Trainee.fromJson(inputJson);

          final group1Dates = output.attendanceDates['group1']!;
          expect(group1Dates.length, 2);
          expect(group1Dates[0].day, 13);
          expect(group1Dates[1].day, 20);
        });
      });
    });

    group('Given trainee with grouped attendance dates', () {
      group('When toJson is called', () {
        test('Then attendance dates should be serialized as grouped map', () {
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
            attendanceDates: {
              'group1': [DateTime(2024, 1, 13), DateTime(2024, 1, 17)],
            },
          );

          final output = input.toJson();

          expect(output['attendanceDates'], {
            'group1': ['2024-01-13', '2024-01-17'],
          });
        });
      });
    });

    group('Given trainee with multi-group attendance dates', () {
      group('When toJson is called', () {
        test('Then all groups should be serialized', () {
          final input = Trainee(
            surname: 'Mustermann',
            forename: 'Max',
            email: 'email@web.de',
            phone: '000111',
            dateOfBirth: '2000-05-01',
            registrationDate: '01.01.2023',
            trainingGroup: Group.group2,
            comment: '',
            isMember: false,
            isTrainer: false,
            attendanceDates: {
              'group1': [DateTime(2024, 1, 13)],
              'group2': [DateTime(2024, 3, 16)],
            },
          );

          final output = input.toJson();

          expect(output['attendanceDates'], {
            'group1': ['2024-01-13'],
            'group2': ['2024-03-16'],
          });
        });
      });
    });

    group('Given trainee without attendance dates', () {
      group('When toJson is called', () {
        test('Then attendance dates should be empty map', () {
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

          expect(output['attendanceDates'], {});
        });
      });
    });

    group('Given trainee with attendance dates', () {
      group('When copyWith is called with new dates', () {
        test('Then attendance dates should be updated', () {
          final trainee = Trainee(
            surname: 'Mustermann',
            forename: 'Max',
            attendanceDates: {
              'group1': [DateTime(2024, 1, 13)],
            },
          );

          final updated = trainee.copyWith(
            attendanceDates: {
              'group1': [DateTime(2024, 1, 13), DateTime(2024, 1, 17)],
            },
          );

          expect(updated.allAttendanceDates.length, 2);
          expect(updated.surname, 'Mustermann');
        });
      });

      group('When copyWithNewGroup is called', () {
        test('Then attendance dates should be preserved', () {
          final trainee = Trainee(
            surname: 'Mustermann',
            forename: 'Max',
            trainingGroup: Group.group1,
            attendanceDates: {
              'group1': [DateTime(2024, 1, 13)],
            },
          );

          final updated = trainee.copyWithNewGroup(Group.group2);

          expect(updated.attendanceDates['group1']!.length, 1);
          expect(updated.trainingGroup, Group.group2);
        });
      });
    });

    group('Given trainee with grouped attendance dates exported and '
        're-imported', () {
      group('When toJson then fromJson is called', () {
        test('Then attendance dates should survive the round-trip', () {
          final original = Trainee(
            surname: 'Mustermann',
            forename: 'Max',
            email: 'email@web.de',
            phone: '000111',
            dateOfBirth: '01.05.2000',
            registrationDate: '01.01.2023',
            trainingGroup: Group.group2,
            comment: 'test',
            isMember: true,
            isTrainer: false,
            attendanceDates: {
              'group1': [DateTime(2024, 1, 13), DateTime(2024, 3, 16)],
              'group2': [DateTime(2024, 6, 1)],
            },
          );

          final json = original.toJson();
          final imported = Trainee.fromJson(json);

          expect(imported.attendanceDates.length, 2);
          expect(imported.attendanceDates['group1']!.length, 2);
          expect(imported.attendanceDates['group1']![0].year, 2024);
          expect(imported.attendanceDates['group1']![0].month, 1);
          expect(imported.attendanceDates['group1']![0].day, 13);
          expect(imported.attendanceDates['group1']![1].month, 3);
          expect(imported.attendanceDates['group1']![1].day, 16);
          expect(imported.attendanceDates['group2']!.length, 1);
          expect(imported.attendanceDates['group2']![0].month, 6);
          expect(imported.attendanceDates['group2']![0].day, 1);
          expect(imported.allAttendanceDates.length, 3);
          expect(imported.surname, 'Mustermann');
          expect(imported.forename, 'Max');
          expect(imported.trainingGroup, Group.group2);
          expect(imported.isMember, true);
        });
      });
    });

    group('Given trainee with allAttendanceDates', () {
      group('When allAttendanceDates is called', () {
        test('Then all dates across groups should be returned', () {
          final trainee = Trainee(
            surname: 'Mustermann',
            forename: 'Max',
            attendanceDates: {
              'group1': [DateTime(2024, 1, 13), DateTime(2024, 1, 20)],
              'group2': [DateTime(2024, 3, 16)],
            },
          );

          expect(trainee.allAttendanceDates.length, 3);
        });
      });
    });

    group('Given trainee with attendanceDatesForGroup', () {
      group('When attendanceDatesForGroup is called', () {
        test('Then dates for the specific group should be returned', () {
          final trainee = Trainee(
            surname: 'Mustermann',
            forename: 'Max',
            attendanceDates: {
              'group1': [DateTime(2024, 1, 13)],
              'group2': [DateTime(2024, 3, 16)],
            },
          );

          expect(trainee.attendanceDatesForGroup('group1').length, 1);
          expect(trainee.attendanceDatesForGroup('group2').length, 1);
          expect(trainee.attendanceDatesForGroup('group3').length, 0);
        });
      });
    });
  });
}
