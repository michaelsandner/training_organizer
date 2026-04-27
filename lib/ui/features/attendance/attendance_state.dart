import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';

@immutable
class AttendanceState with EquatableMixin {
  final DateTime selectedDate;
  final bool showStatistics;

  const AttendanceState({
    required this.selectedDate,
    this.showStatistics = false,
  });

  factory AttendanceState.initial() {
    return AttendanceState(
      selectedDate: getDefaultAttendanceDate(),
    );
  }

  AttendanceState copyWith({
    DateTime? selectedDate,
    bool? showStatistics,
  }) {
    return AttendanceState(
      selectedDate: selectedDate ?? this.selectedDate,
      showStatistics: showStatistics ?? this.showStatistics,
    );
  }

  @override
  List<Object?> get props => [selectedDate, showStatistics];

  static DateTime getDefaultAttendanceDate({FilterableGroup? group}) {
    final allowedWeekday = getAllowedWeekday(group);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (allowedWeekday != null) {
      if (today.weekday == allowedWeekday) {
        return today;
      }
      final daysUntil = (allowedWeekday - today.weekday + 7) % 7;
      return today.add(Duration(days: daysUntil == 0 ? 7 : daysUntil));
    }

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

  static int? getAllowedWeekday(FilterableGroup? group) {
    switch (group) {
      case FilterableGroup.group1:
      case FilterableGroup.group2:
      case FilterableGroup.group4:
      case FilterableGroup.group5:
        return DateTime.saturday;
      case FilterableGroup.wednesday:
      case FilterableGroup.active:
      case FilterableGroup.leisure:
        return DateTime.wednesday;
      default:
        return null;
    }
  }
}
