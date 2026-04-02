import 'package:flutter/material.dart';
import 'package:training_organizer/domain/usecases/get_attendance_statistics_usecase.dart';

class AttendanceStatisticsSumRow {
  static Map<int, int> _computeGroupTotals(
      AttendanceSectionData sectionData) {
    final totals = <int, int>{};
    for (var i = 0; i < sectionData.groupData.length; i++) {
      var total = 0;
      for (final count in sectionData.groupData[i].counts.values) {
        total += count;
      }
      totals[i] = total;
    }
    return totals;
  }

  static TableRow buildRow({
    required AttendanceSectionData sectionData,
  }) {
    final groupTotals = _computeGroupTotals(sectionData);
    var grandTotal = 0;
    for (final total in groupTotals.values) {
      grandTotal += total;
    }

    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      children: [
        const Padding(
          padding: EdgeInsets.all(6.0),
          child: Text(
            'Gesamt',
            style: TextStyle(
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
              '${groupTotals[i] ?? 0}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            '$grandTotal',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
