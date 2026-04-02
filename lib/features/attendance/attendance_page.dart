import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/attendance/attendance_button_row.dart';
import 'package:training_organizer/features/attendance/attendance_cubit.dart';
import 'package:training_organizer/features/attendance/attendance_date_picker.dart';
import 'package:training_organizer/features/attendance/attendance_list_header.dart';
import 'package:training_organizer/features/attendance/attendance_list_item.dart';
import 'package:training_organizer/features/attendance/attendance_state.dart';
import 'package:training_organizer/features/attendance/attendance_statistics_view.dart';
import 'package:training_organizer/features/attendance/attendance_view_toggle.dart';
import 'package:training_organizer/features/edit/drop_down.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_cubit.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_state.dart';
import 'package:training_organizer/features/overview/trainees_cubit.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/services/platform_service.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocListener<FilterTraineesCubit, FilterTraineesState>(
      listener: (context, filterState) {
        context
            .read<AttendanceCubit>()
            .adjustDateForGroup(filterState.selectedGroup);
      },
      child: BlocBuilder<TraineesCubit, TraineesState>(
        builder: (context, traineesState) {
          if (traineesState.trainees.isEmpty) {
            return const Center(
              child: Text('Keine Teilnehmer vorhanden'),
            );
          }
          return BlocBuilder<AttendanceCubit, AttendanceState>(
            builder: (context, attendanceState) {
              if (attendanceState.showStatistics) {
                return Padding(
                  padding: isMobile(screenSize)
                      ? const EdgeInsets.all(5)
                      : const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AttendanceViewToggle(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: AttendanceStatisticsView(
                          trainees: traineesState.trainees,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: isMobile(screenSize)
                    ? const EdgeInsets.all(5)
                    : const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DropDown(),
                              const AttendanceDatePicker(),
                              const AttendanceViewToggle(),
                            ],
                          ),
                        ),
                        const AttendanceListHeader(),
                        Expanded(
                          child: BlocBuilder<FilterTraineesCubit,
                              FilterTraineesState>(
                            builder: (context, filterState) {
                              return BlocBuilder<AttendanceCubit,
                                  AttendanceState>(
                                builder: (context, attendanceState) {
                                  final trainees =
                                      filterState.selectedTrainees;
                                  return ListView.builder(
                                    itemCount: trainees.length,
                                    itemBuilder: (context, index) {
                                      return AttendanceListItem(
                                        trainee: trainees[index],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const AttendanceButtonRow(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
