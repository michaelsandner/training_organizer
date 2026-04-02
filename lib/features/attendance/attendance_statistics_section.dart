import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_organizer/domain/usecases/get_attendance_statistics_usecase.dart';
import 'package:training_organizer/features/attendance/attendance_statistics_group_row.dart';
import 'package:training_organizer/features/attendance/attendance_statistics_sum_row.dart';

class AttendanceStatisticsSection extends StatelessWidget {
  final String title;
  final AttendanceSectionData sectionData;

  static const double groupLabelWidth = 100.0;
  static const double cellWidth = 50.0;

  const AttendanceStatisticsSection({
    super.key,
    required this.title,
    required this.sectionData,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateHeaderRow(
                dates: sectionData.dates,
                dateFormat: dateFormat,
              ),
              AttendanceStatisticsSumRow(
                dates: sectionData.dates,
                sums: sectionData.sums,
              ),
              ...sectionData.groupData.map(
                (data) => AttendanceStatisticsGroupRow(
                  group: data.group,
                  dates: sectionData.dates,
                  counts: data.counts,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateHeaderRow extends StatelessWidget {
  final List<DateTime> dates;
  final DateFormat dateFormat;

  const _DateHeaderRow({
    required this.dates,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: AttendanceStatisticsSection.groupLabelWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Gruppe',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ...dates.map(
          (date) => SizedBox(
            width: AttendanceStatisticsSection.cellWidth,
            child: Text(
              dateFormat.format(date),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
