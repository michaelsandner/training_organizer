import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/attendance/attendance_state.dart';
import 'package:training_organizer/features/overview/trainees_cubit.dart';
import 'package:training_organizer/model/trainee.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceState.initial());

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void toggleAttendance(Trainee trainee, TraineesCubit traineesCubit) {
    final selectedDate = state.selectedDate;
    final hasDate = trainee.attendanceDates.any(
      (d) =>
          d.year == selectedDate.year &&
          d.month == selectedDate.month &&
          d.day == selectedDate.day,
    );

    final updatedDates = List<DateTime>.from(trainee.attendanceDates);

    if (hasDate) {
      updatedDates.removeWhere(
        (d) =>
            d.year == selectedDate.year &&
            d.month == selectedDate.month &&
            d.day == selectedDate.day,
      );
    } else {
      updatedDates.add(selectedDate);
    }

    final updatedTrainee = trainee.copyWith(attendanceDates: updatedDates);
    traineesCubit.replaceTrainee(trainee, updatedTrainee);
  }

  bool isAttending(Trainee trainee) {
    final selectedDate = state.selectedDate;
    return trainee.attendanceDates.any(
      (d) =>
          d.year == selectedDate.year &&
          d.month == selectedDate.month &&
          d.day == selectedDate.day,
    );
  }

  int getAttendanceCount(Trainee trainee) {
    return trainee.attendanceDates.length;
  }
}
