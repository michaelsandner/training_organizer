import 'package:flutter/material.dart';
import 'package:training_organizer/features/attendance/attendance_statistics_section.dart';

class AttendanceStatisticsSumRow extends StatelessWidget {
  final List<DateTime> dates;
  final Map<DateTime, int> sums;

  const AttendanceStatisticsSumRow({
    super.key,
    required this.dates,
    required this.sums,
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
              'Gesamt',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        ...dates.map(
          (date) => SizedBox(
            width: AttendanceStatisticsSection.cellWidth,
            child: Text(
              '${sums[date] ?? 0}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
