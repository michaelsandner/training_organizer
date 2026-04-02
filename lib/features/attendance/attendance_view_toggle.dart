import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/attendance/attendance_cubit.dart';
import 'package:training_organizer/features/attendance/attendance_state.dart';

class AttendanceViewToggle extends StatelessWidget {
  const AttendanceViewToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        return IconButton(
          icon: Icon(
            state.showStatistics ? Icons.edit : Icons.bar_chart,
          ),
          tooltip:
              state.showStatistics ? 'Bearbeiten' : 'Statistik',
          onPressed: () {
            context.read<AttendanceCubit>().toggleStatisticsView();
          },
        );
      },
    );
  }
}
