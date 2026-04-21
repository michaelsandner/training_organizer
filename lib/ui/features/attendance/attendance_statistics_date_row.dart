import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_organizer/domain/usecases/get_attendance_statistics_usecase.dart';

class AttendanceStatisticsDateRow {
  static TableRow buildRow({
    required DateTime date,
    required DateFormat dateFormat,
    required AttendanceSectionData sectionData,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            dateFormat.format(date),
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            '${sectionData.sums[date] ?? 0}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ...sectionData.groupData.map(
          (data) => Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              '${data.counts[date] ?? 0}',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
