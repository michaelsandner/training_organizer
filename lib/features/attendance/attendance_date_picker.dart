import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/attendance/attendance_cubit.dart';
import 'package:training_organizer/features/attendance/attendance_state.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_cubit.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_state.dart';

class AttendanceDatePicker extends StatelessWidget {
  const AttendanceDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterTraineesCubit, FilterTraineesState>(
      builder: (context, filterState) {
        return BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            final cubit = context.read<AttendanceCubit>();
            final allowedWeekday =
                AttendanceState.getAllowedWeekday(filterState.selectedGroup);
            final formattedDate =
                '${state.selectedDate.day.toString().padLeft(2, '0')}.${state.selectedDate.month.toString().padLeft(2, '0')}.${state.selectedDate.year}';
            return TextButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: state.selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  selectableDayPredicate: (DateTime day) {
                    if (allowedWeekday != null) {
                      return day.weekday == allowedWeekday;
                    }
                    return day.weekday == DateTime.wednesday ||
                        day.weekday == DateTime.saturday;
                  },
                );
                if (picked != null) {
                  cubit.setSelectedDate(picked);
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(formattedDate),
            );
          },
        );
      },
    );
  }
}
