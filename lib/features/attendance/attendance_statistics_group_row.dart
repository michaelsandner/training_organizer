import 'package:flutter/material.dart';
import 'package:training_organizer/features/attendance/attendance_statistics_section.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/training_group.dart';

class AttendanceStatisticsGroupRow extends StatelessWidget {
  final Group group;
  final List<DateTime> dates;
  final Map<DateTime, int> counts;

  const AttendanceStatisticsGroupRow({
    super.key,
    required this.group,
    required this.dates,
    required this.counts,
  });

  String _groupDisplayName(Group group) {
    return trainingGroups
        .singleWhere((element) => element.group == group)
        .name;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AttendanceStatisticsSection.groupLabelWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _groupDisplayName(group),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
        ...dates.map(
          (date) => SizedBox(
            width: AttendanceStatisticsSection.cellWidth,
            child: Text(
              '${counts[date] ?? 0}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}
