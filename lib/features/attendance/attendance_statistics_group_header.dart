import 'package:flutter/material.dart';
import 'package:training_organizer/domain/usecases/get_attendance_statistics_usecase.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/training_group.dart';

class AttendanceStatisticsGroupHeader {
  static String _groupDisplayName(Group group) {
    return trainingGroups
        .singleWhere((element) => element.group == group)
        .name;
  }

  static TableRow buildRow({
    required AttendanceSectionData sectionData,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
      ),
      children: [
        const Padding(
          padding: EdgeInsets.all(6.0),
          child: Text(
            'Datum',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ...sectionData.groupData.map(
          (data) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                _groupDisplayName(data.group),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              'Gesamt',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
