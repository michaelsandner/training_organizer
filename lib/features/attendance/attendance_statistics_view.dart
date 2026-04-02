import 'package:flutter/material.dart';
import 'package:training_organizer/domain/usecases/get_attendance_statistics_usecase.dart';
import 'package:training_organizer/features/attendance/attendance_statistics_section.dart';
import 'package:training_organizer/model/trainee.dart';

class AttendanceStatisticsView extends StatelessWidget {
  final List<Trainee> trainees;

  const AttendanceStatisticsView({
    super.key,
    required this.trainees,
  });

  @override
  Widget build(BuildContext context) {
    final useCase = GetAttendanceStatisticsUseCase();

    final saturdayData = useCase.execute(
      trainees,
      GetAttendanceStatisticsUseCase.saturdayGroups,
      DateTime.saturday,
    );

    final wednesdayData = useCase.execute(
      trainees,
      GetAttendanceStatisticsUseCase.wednesdayGroups,
      DateTime.wednesday,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (saturdayData.dates.isNotEmpty)
            AttendanceStatisticsSection(
              title: 'Samstag',
              sectionData: saturdayData,
            ),
          if (wednesdayData.dates.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: AttendanceStatisticsSection(
                title: 'Mittwoch',
                sectionData: wednesdayData,
              ),
            ),
          if (saturdayData.dates.isEmpty && wednesdayData.dates.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Keine Anwesenheitsdaten vorhanden'),
              ),
            ),
        ],
      ),
    );
  }
}
