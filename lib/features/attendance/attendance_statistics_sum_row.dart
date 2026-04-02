import 'package:flutter/material.dart';
import 'package:training_organizer/domain/usecases/get_attendance_statistics_usecase.dart';

class AttendanceStatisticsSumRow {
  static Map<int, double> _computeGroupAverages(
      AttendanceSectionData sectionData) {
    final averages = <int, double>{};
    final dateCount = sectionData.dates.length;
    for (var i = 0; i < sectionData.groupData.length; i++) {
      var total = 0;
      for (final count in sectionData.groupData[i].counts.values) {
        total += count;
      }
      averages[i] = dateCount > 0 ? total / dateCount : 0;
    }
    return averages;
  }

  static String _formatAverage(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  static TableRow buildRow({
    required AttendanceSectionData sectionData,
  }) {
    final groupAverages = _computeGroupAverages(sectionData);
    var totalSum = 0.0;
    for (final avg in groupAverages.values) {
      totalSum += avg;
    }

    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      children: [
        const Padding(
          padding: EdgeInsets.all(6.0),
          child: Text(
            'ø',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            _formatAverage(totalSum),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ...List.generate(
          sectionData.groupData.length,
          (i) => Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              _formatAverage(groupAverages[i] ?? 0),
              style: const TextStyle(
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
