import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/features/attendance/attendance_cubit.dart';
import 'package:training_organizer/features/attendance/attendance_state.dart';
import 'package:training_organizer/features/overview/trainees_cubit.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_cubit.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_state.dart';

class MockFilterTraineesCubit extends Mock implements FilterTraineesCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(Group.waitingList);
    registerFallbackValue(FilterableGroup.all);
    registerFallbackValue(<Trainee>[]);
  });

  group('AttendanceCubit', () {
    late AttendanceCubit cubit;

    setUp(() {
      cubit = AttendanceCubit();
    });

    group('Given initial state', () {
      group('When cubit is created', () {
        test('Then selected date should be a wednesday or saturday', () {
          final selectedDate = cubit.state.selectedDate;
          expect(
            selectedDate.weekday == DateTime.wednesday ||
                selectedDate.weekday == DateTime.saturday,
            true,
          );
        });
      });
    });

    group('Given a specific date', () {
      final testDate = DateTime(2024, 1, 17); // Wednesday

      group('When setSelectedDate is called', () {
        blocTest<AttendanceCubit, AttendanceState>(
          'Then selected date should be updated',
          build: () => AttendanceCubit(),
          act: (cubit) => cubit.setSelectedDate(testDate),
          verify: (cubit) {
            expect(cubit.state.selectedDate, testDate);
          },
        );
      });
    });

    group('Given a trainee without attendance dates', () {
      final trainee = Trainee(
        surname: 'Musterman',
        forename: 'Max',
        email: 'email@email.de',
        dateOfBirth: '2000-10-10',
        trainingGroup: Group.group1,
      );

      group('When isAttending is called', () {
        test('Then should return false', () {
          expect(cubit.isAttending(trainee), false);
        });
      });

      group('When getAttendanceCount is called', () {
        test('Then should return 0', () {
          expect(cubit.getAttendanceCount(trainee), 0);
        });
      });

      group('When toggleAttendance is called', () {
        test('Then trainee should have the selected date added', () {
          final mockFilterTraineesCubit = MockFilterTraineesCubit();
          when(() => mockFilterTraineesCubit.state)
              .thenReturn(FilterTraineesState.initial());
          when(() => mockFilterTraineesCubit.setSelectedGroup(any(), any()))
              .thenAnswer((_) {});
          when(() => mockFilterTraineesCubit.getFilteredGroup(any()))
              .thenReturn(FilterableGroup.all);

          final traineesCubit = TraineesCubit()
            ..setFilterTraineesCubit(mockFilterTraineesCubit);
          traineesCubit.emit(TraineesState(trainees: [trainee]));

          final selectedDate = cubit.state.selectedDate;
          cubit.toggleAttendance(trainee, traineesCubit);

          final updatedTrainee = traineesCubit.state.trainees.first;
          expect(updatedTrainee.attendanceDates.length, 1);
          expect(updatedTrainee.attendanceDates.first.year, selectedDate.year);
          expect(
              updatedTrainee.attendanceDates.first.month, selectedDate.month);
          expect(updatedTrainee.attendanceDates.first.day, selectedDate.day);
        });
      });
    });

    group('Given a trainee with attendance date matching selected date', () {
      group('When toggleAttendance is called', () {
        test('Then the matching date should be removed', () {
          final mockFilterTraineesCubit = MockFilterTraineesCubit();
          when(() => mockFilterTraineesCubit.state)
              .thenReturn(FilterTraineesState.initial());
          when(() => mockFilterTraineesCubit.setSelectedGroup(any(), any()))
              .thenAnswer((_) {});
          when(() => mockFilterTraineesCubit.getFilteredGroup(any()))
              .thenReturn(FilterableGroup.all);

          final selectedDate = cubit.state.selectedDate;
          final trainee = Trainee(
            surname: 'Musterman',
            forename: 'Max',
            email: 'email@email.de',
            dateOfBirth: '2000-10-10',
            trainingGroup: Group.group1,
            attendanceDates: [selectedDate],
          );

          final traineesCubit = TraineesCubit()
            ..setFilterTraineesCubit(mockFilterTraineesCubit);
          traineesCubit.emit(TraineesState(trainees: [trainee]));

          cubit.toggleAttendance(trainee, traineesCubit);

          final updatedTrainee = traineesCubit.state.trainees.first;
          expect(updatedTrainee.attendanceDates.isEmpty, true);
        });
      });

      group('When isAttending is called', () {
        test('Then should return true', () {
          final selectedDate = cubit.state.selectedDate;
          final trainee = Trainee(
            surname: 'Musterman',
            forename: 'Max',
            email: 'email@email.de',
            dateOfBirth: '2000-10-10',
            trainingGroup: Group.group1,
            attendanceDates: [selectedDate],
          );

          expect(cubit.isAttending(trainee), true);
        });
      });
    });

    group('Given a trainee with multiple attendance dates', () {
      final trainee = Trainee(
        surname: 'Musterman',
        forename: 'Max',
        email: 'email@email.de',
        dateOfBirth: '2000-10-10',
        trainingGroup: Group.group1,
        attendanceDates: [
          DateTime(2024, 1, 13),
          DateTime(2024, 1, 17),
          DateTime(2024, 1, 20),
        ],
      );

      group('When getAttendanceCount is called', () {
        test('Then should return 3', () {
          expect(cubit.getAttendanceCount(trainee), 3);
        });
      });
    });

    group('Given a block group is selected', () {
      group('When adjustDateForGroup is called with group1', () {
        blocTest<AttendanceCubit, AttendanceState>(
          'Then selected date should be a saturday',
          build: () => AttendanceCubit(),
          act: (cubit) =>
              cubit.adjustDateForGroup(FilterableGroup.group1),
          verify: (cubit) {
            expect(cubit.state.selectedDate.weekday, DateTime.saturday);
          },
        );
      });
    });

    group('Given a wednesday group is selected', () {
      group('When adjustDateForGroup is called with wednesday', () {
        blocTest<AttendanceCubit, AttendanceState>(
          'Then selected date should be a wednesday',
          build: () {
            final cubit = AttendanceCubit();
            cubit.setSelectedDate(DateTime(2024, 1, 13)); // Saturday
            return cubit;
          },
          act: (cubit) =>
              cubit.adjustDateForGroup(FilterableGroup.wednesday),
          verify: (cubit) {
            expect(cubit.state.selectedDate.weekday, DateTime.wednesday);
          },
        );
      });
    });
  });

  group('AttendanceState', () {
    group('Given getDefaultAttendanceDate', () {
      group('When called without group', () {
        test('Then should return a wednesday or saturday', () {
          final date = AttendanceState.getDefaultAttendanceDate();
          expect(
            date.weekday == DateTime.wednesday ||
                date.weekday == DateTime.saturday,
            true,
          );
        });
      });

      group('When called with a block group', () {
        test('Then should return a saturday', () {
          final date = AttendanceState.getDefaultAttendanceDate(
              group: FilterableGroup.group1);
          expect(date.weekday, DateTime.saturday);
        });
      });

      group('When called with wednesday group', () {
        test('Then should return a wednesday', () {
          final date = AttendanceState.getDefaultAttendanceDate(
              group: FilterableGroup.wednesday);
          expect(date.weekday, DateTime.wednesday);
        });
      });

      group('When called with active group', () {
        test('Then should return a wednesday', () {
          final date = AttendanceState.getDefaultAttendanceDate(
              group: FilterableGroup.active);
          expect(date.weekday, DateTime.wednesday);
        });
      });

      group('When called with leisure group', () {
        test('Then should return a wednesday', () {
          final date = AttendanceState.getDefaultAttendanceDate(
              group: FilterableGroup.leisure);
          expect(date.weekday, DateTime.wednesday);
        });
      });
    });

    group('Given getAllowedWeekday', () {
      group('When called with block groups', () {
        test('Then should return saturday', () {
          expect(AttendanceState.getAllowedWeekday(FilterableGroup.group1),
              DateTime.saturday);
          expect(AttendanceState.getAllowedWeekday(FilterableGroup.group2),
              DateTime.saturday);
          expect(AttendanceState.getAllowedWeekday(FilterableGroup.group3),
              DateTime.saturday);
          expect(AttendanceState.getAllowedWeekday(FilterableGroup.group4),
              DateTime.saturday);
          expect(AttendanceState.getAllowedWeekday(FilterableGroup.group5),
              DateTime.saturday);
        });
      });

      group('When called with wednesday, active or leisure', () {
        test('Then should return wednesday', () {
          expect(
              AttendanceState.getAllowedWeekday(FilterableGroup.wednesday),
              DateTime.wednesday);
          expect(AttendanceState.getAllowedWeekday(FilterableGroup.active),
              DateTime.wednesday);
          expect(AttendanceState.getAllowedWeekday(FilterableGroup.leisure),
              DateTime.wednesday);
        });
      });

      group('When called with all or null', () {
        test('Then should return null', () {
          expect(
              AttendanceState.getAllowedWeekday(FilterableGroup.all), null);
          expect(AttendanceState.getAllowedWeekday(null), null);
        });
      });
    });
  });
}
