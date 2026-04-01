import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class AttendanceState with EquatableMixin {
  final DateTime selectedDate;

  const AttendanceState({
    required this.selectedDate,
  });

  factory AttendanceState.initial() {
    return AttendanceState(
      selectedDate: getDefaultAttendanceDate(),
    );
  }

  AttendanceState copyWith({
    DateTime? selectedDate,
  }) {
    return AttendanceState(
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [selectedDate];

  static DateTime getDefaultAttendanceDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (today.weekday == DateTime.wednesday ||
        today.weekday == DateTime.saturday) {
      return today;
    }

    final daysUntilWednesday =
        (DateTime.wednesday - today.weekday + 7) % 7;
    final daysUntilSaturday =
        (DateTime.saturday - today.weekday + 7) % 7;

    final daysToAdd = daysUntilWednesday < daysUntilSaturday
        ? daysUntilWednesday
        : daysUntilSaturday;
    return today.add(Duration(days: daysToAdd));
  }
}
