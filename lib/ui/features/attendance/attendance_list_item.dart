import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/attendance/attendance_cubit.dart';
import 'package:training_organizer/ui/features/overview/item_text_box.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/model/trainee.dart';

class AttendanceListItem extends StatelessWidget {
  final Trainee trainee;

  const AttendanceListItem({
    super.key,
    required this.trainee,
  });

  @override
  Widget build(BuildContext context) {
    final attendanceCubit = context.read<AttendanceCubit>();
    final traineesCubit = context.read<TraineesCubit>();
    final isAttending = attendanceCubit.isAttending(trainee);
    final attendanceCount = attendanceCubit.getAttendanceCount(trainee);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ItemTextBox(
              text: '${trainee.surname} ${trainee.forename}',
              isMember: trainee.isMember,
            ),
          ),
          SizedBox(
            width: 80,
            child: Center(
              child: Checkbox(
                value: isAttending,
                onChanged: (bool? value) {
                  attendanceCubit.toggleAttendance(trainee, traineesCubit);
                },
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '$attendanceCount',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
