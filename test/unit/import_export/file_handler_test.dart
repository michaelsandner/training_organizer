import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/data/file_handler.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  group('FileExporter JSON round-trip', () {
    group('Given trainees with attendance dates', () {
      group('When encodeJson then jsonDecode and fromJson', () {
        test('Then all trainee data including attendance dates survives', () {
          final trainees = [
            Trainee(
              surname: 'Müller',
              forename: 'Hans',
              email: 'hans@test.de',
              phone: '0123456789',
              dateOfBirth: '01.01.1990',
              registrationDate: '01.01.2020',
              trainingGroup: Group.group1,
              comment: 'Kommentar',
              isMember: true,
              isTrainer: false,
              attendanceDates: {
                'group1': [
                  DateTime(2024, 1, 13),
                  DateTime(2024, 3, 16),
                ],
              },
            ),
            Trainee(
              surname: 'Schmidt',
              forename: 'Anna',
              email: 'anna@test.de',
              phone: '0987654321',
              dateOfBirth: '15.06.2000',
              registrationDate: '10.03.2022',
              trainingGroup: Group.wednesday,
              comment: '',
              isMember: false,
              isTrainer: true,
              attendanceDates: {
                'wednesday': [
                  DateTime(2024, 1, 17),
                  DateTime(2024, 1, 24),
                  DateTime(2024, 2, 7),
                ],
              },
            ),
          ];

          final exporter = FileExporter();
          final jsonString = exporter.encodeJson(trainees);
          final inputMap = jsonDecode(jsonString) as Map<String, dynamic>;
          final list = inputMap['trainees'] as List;
          final imported =
              list.map((t) => Trainee.fromJson(t)).toList();

          expect(imported.length, 2);

          expect(imported[0].surname, 'Müller');
          expect(imported[0].forename, 'Hans');
          expect(imported[0].trainingGroup, Group.group1);
          expect(imported[0].allAttendanceDates.length, 2);
          expect(imported[0].attendanceDates['group1']![0].year, 2024);
          expect(imported[0].attendanceDates['group1']![0].month, 1);
          expect(imported[0].attendanceDates['group1']![0].day, 13);
          expect(imported[0].attendanceDates['group1']![1].month, 3);
          expect(imported[0].attendanceDates['group1']![1].day, 16);

          expect(imported[1].surname, 'Schmidt');
          expect(imported[1].trainingGroup, Group.wednesday);
          expect(imported[1].isTrainer, true);
          expect(imported[1].allAttendanceDates.length, 3);
          expect(imported[1].attendanceDates['wednesday']![0].month, 1);
          expect(imported[1].attendanceDates['wednesday']![0].day, 17);
        });
      });
    });

    group('Given trainees without attendance dates', () {
      group('When encodeJson then jsonDecode and fromJson', () {
        test('Then trainees should have empty attendance dates', () {
          final trainees = [
            Trainee(
              surname: 'Test',
              forename: 'User',
              trainingGroup: Group.waitingList,
            ),
          ];

          final exporter = FileExporter();
          final jsonString = exporter.encodeJson(trainees);
          final inputMap = jsonDecode(jsonString) as Map<String, dynamic>;
          final list = inputMap['trainees'] as List;
          final imported =
              list.map((t) => Trainee.fromJson(t)).toList();

          expect(imported.length, 1);
          expect(imported[0].attendanceDates.isEmpty, true);
          expect(imported[0].allAttendanceDates.isEmpty, true);
        });
      });
    });

    group('Given old export format without attendanceDates field', () {
      group('When fromJson is called', () {
        test('Then trainee should have empty attendance dates', () {
          final oldFormatJson = {
            'surname': 'Alt',
            'forename': 'Format',
            'email': 'alt@test.de',
            'dateOfBirth': '01.01.2000',
            'registrationDate': '01.01.2020',
            'trainingGroup': 'group1',
            'phone': '0123456789',
            'comment': '',
            'isMember': true,
            'isTrainer': false,
            'qualifications': [],
          };

          final imported = Trainee.fromJson(oldFormatJson);

          expect(imported.surname, 'Alt');
          expect(imported.attendanceDates.isEmpty, true);
        });
      });
    });
  });
}
