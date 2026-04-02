import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_organizer/domain/usecases/get_attendance_statistics_usecase.dart';
import 'package:training_organizer/features/attendance/attendance_statistics_date_row.dart';
import 'package:training_organizer/features/attendance/attendance_statistics_group_header.dart';
import 'package:training_organizer/features/attendance/attendance_statistics_sum_row.dart';

class AttendanceStatisticsSection extends StatelessWidget {
  final String title;
  final AttendanceSectionData sectionData;

  const AttendanceStatisticsSection({
    super.key,
    required this.title,
    required this.sectionData,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.');
    final groupCount = sectionData.groupData.length;

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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 32,
            ),
            child: Table(
              border: TableBorder.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: const FixedColumnWidth(80),
                for (int i = 1; i <= groupCount; i++)
                  i: const FlexColumnWidth(1),
                groupCount + 1: const FixedColumnWidth(60),
              },
              children: [
                AttendanceStatisticsGroupHeader.buildRow(
                  sectionData: sectionData,
                ),
                ...sectionData.dates.map(
                  (date) => AttendanceStatisticsDateRow.buildRow(
                    date: date,
                    dateFormat: dateFormat,
                    sectionData: sectionData,
                  ),
                ),
                AttendanceStatisticsSumRow.buildRow(
                  sectionData: sectionData,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
