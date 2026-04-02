import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/usecases/get_attendance_statistics_usecase.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  late GetAttendanceStatisticsUseCase useCase;

  setUp(() {
    useCase = GetAttendanceStatisticsUseCase();
  });

  group('GetAttendanceStatisticsUseCase', () {
    group('Given trainees with Saturday attendance dates', () {
      final saturday1 = DateTime(2024, 1, 6); // Saturday
      final saturday2 = DateTime(2024, 1, 13); // Saturday

      final trainees = [
        Trainee(
          forename: 'Max',
          surname: 'Mustermann',
          trainingGroup: Group.group1,
          attendanceDates: [saturday1, saturday2],
        ),
        Trainee(
          forename: 'Anna',
          surname: 'Schmidt',
          trainingGroup: Group.group1,
          attendanceDates: [saturday1],
        ),
        Trainee(
          forename: 'Hans',
          surname: 'Mueller',
          trainingGroup: Group.group2,
          attendanceDates: [saturday1, saturday2],
        ),
      ];

      group('When execute is called with Saturday groups', () {
        test('Then should collect correct dates sorted', () {
          final result = useCase.execute(
            trainees,
            GetAttendanceStatisticsUseCase.saturdayGroups,
            DateTime.saturday,
          );

          expect(result.dates, [saturday1, saturday2]);
        });

        test('Then should compute correct group counts', () {
          final result = useCase.execute(
            trainees,
            GetAttendanceStatisticsUseCase.saturdayGroups,
            DateTime.saturday,
          );

          final group1Data =
              result.groupData.firstWhere((d) => d.group == Group.group1);
          expect(group1Data.counts[saturday1], 2);
          expect(group1Data.counts[saturday2], 1);

          final group2Data =
              result.groupData.firstWhere((d) => d.group == Group.group2);
          expect(group2Data.counts[saturday1], 1);
          expect(group2Data.counts[saturday2], 1);
        });

        test('Then should compute correct sums per date', () {
          final result = useCase.execute(
            trainees,
            GetAttendanceStatisticsUseCase.saturdayGroups,
            DateTime.saturday,
          );

          expect(result.sums[saturday1], 3);
          expect(result.sums[saturday2], 2);
        });

        test('Then should include groups with zero counts', () {
          final result = useCase.execute(
            trainees,
            GetAttendanceStatisticsUseCase.saturdayGroups,
            DateTime.saturday,
          );

          final group4Data =
              result.groupData.firstWhere((d) => d.group == Group.group4);
          expect(group4Data.counts[saturday1], 0);
          expect(group4Data.counts[saturday2], 0);

          final group5Data =
              result.groupData.firstWhere((d) => d.group == Group.group5);
          expect(group5Data.counts[saturday1], 0);
          expect(group5Data.counts[saturday2], 0);
        });
      });
    });

    group('Given trainees with Wednesday attendance dates', () {
      final wednesday1 = DateTime(2024, 1, 3); // Wednesday
      final wednesday2 = DateTime(2024, 1, 10); // Wednesday

      final trainees = [
        Trainee(
          forename: 'Lisa',
          surname: 'Weber',
          trainingGroup: Group.wednesday,
          attendanceDates: [wednesday1, wednesday2],
        ),
        Trainee(
          forename: 'Tom',
          surname: 'Fischer',
          trainingGroup: Group.active,
          attendanceDates: [wednesday1],
        ),
      ];

      group('When execute is called with Wednesday groups', () {
        test('Then should compute correct counts and sums', () {
          final result = useCase.execute(
            trainees,
            GetAttendanceStatisticsUseCase.wednesdayGroups,
            DateTime.wednesday,
          );

          expect(result.dates, [wednesday1, wednesday2]);

          final wednesdayData =
              result.groupData.firstWhere((d) => d.group == Group.wednesday);
          expect(wednesdayData.counts[wednesday1], 1);
          expect(wednesdayData.counts[wednesday2], 1);

          final activeData =
              result.groupData.firstWhere((d) => d.group == Group.active);
          expect(activeData.counts[wednesday1], 1);
          expect(activeData.counts[wednesday2], 0);

          expect(result.sums[wednesday1], 2);
          expect(result.sums[wednesday2], 1);
        });
      });
    });

    group('Given trainees with no matching attendance dates', () {
      final trainees = [
        Trainee(
          forename: 'Max',
          surname: 'Mustermann',
          trainingGroup: Group.group1,
          attendanceDates: [],
        ),
      ];

      group('When execute is called', () {
        test('Then should return empty dates', () {
          final result = useCase.execute(
            trainees,
            GetAttendanceStatisticsUseCase.saturdayGroups,
            DateTime.saturday,
          );

          expect(result.dates, isEmpty);
          expect(result.sums, isEmpty);
        });
      });
    });

    group('Given trainees from different groups', () {
      final saturday = DateTime(2024, 1, 6); // Saturday

      final trainees = [
        Trainee(
          forename: 'Max',
          surname: 'Mustermann',
          trainingGroup: Group.group1,
          attendanceDates: [saturday],
        ),
        Trainee(
          forename: 'Lisa',
          surname: 'Weber',
          trainingGroup: Group.wednesday,
          attendanceDates: [DateTime(2024, 1, 3)], // Wednesday
        ),
      ];

      group('When execute is called with Saturday groups', () {
        test('Then should only include Saturday group trainees', () {
          final result = useCase.execute(
            trainees,
            GetAttendanceStatisticsUseCase.saturdayGroups,
            DateTime.saturday,
          );

          expect(result.dates, [saturday]);
          expect(result.sums[saturday], 1);
        });
      });
    });

    group('Given trainees with Wednesday dates in Saturday group', () {
      final wednesday = DateTime(2024, 1, 3); // Wednesday

      final trainees = [
        Trainee(
          forename: 'Max',
          surname: 'Mustermann',
          trainingGroup: Group.group1,
          attendanceDates: [wednesday],
        ),
      ];

      group('When execute is called with Saturday groups', () {
        test('Then should not include non-Saturday dates', () {
          final result = useCase.execute(
            trainees,
            GetAttendanceStatisticsUseCase.saturdayGroups,
            DateTime.saturday,
          );

          expect(result.dates, isEmpty);
        });
      });
    });
  });
}
