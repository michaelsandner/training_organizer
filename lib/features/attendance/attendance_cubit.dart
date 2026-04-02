import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/attendance/attendance_state.dart';
import 'package:training_organizer/features/overview/trainees_cubit.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceState.initial());

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void toggleStatisticsView() {
    emit(state.copyWith(showStatistics: !state.showStatistics));
  }

  void adjustDateForGroup(FilterableGroup group) {
    final allowedWeekday = AttendanceState.getAllowedWeekday(group);
    if (allowedWeekday != null &&
        state.selectedDate.weekday != allowedWeekday) {
      final newDate =
          AttendanceState.getDefaultAttendanceDate(group: group);
      emit(state.copyWith(selectedDate: newDate));
    }
  }

  void toggleAttendance(Trainee trainee, TraineesCubit traineesCubit) {
    final selectedDate = state.selectedDate;
    final hasDate =
        trainee.attendanceDates.any((d) => _isSameDate(d, selectedDate));

    final updatedDates = List<DateTime>.from(trainee.attendanceDates);

    if (hasDate) {
      updatedDates.removeWhere((d) => _isSameDate(d, selectedDate));
    } else {
      updatedDates.add(selectedDate);
    }

    final updatedTrainee = trainee.copyWith(attendanceDates: updatedDates);
    traineesCubit.replaceTrainee(trainee, updatedTrainee);
  }

  bool isAttending(Trainee trainee) {
    final selectedDate = state.selectedDate;
    return trainee.attendanceDates.any((d) => _isSameDate(d, selectedDate));
  }

  int getAttendanceCount(Trainee trainee) {
    return trainee.attendanceDates.length;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
