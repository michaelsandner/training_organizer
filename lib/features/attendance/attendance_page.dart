import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/attendance/attendance_cubit.dart';
import 'package:training_organizer/features/attendance/attendance_state.dart';
import 'package:training_organizer/features/attendance/attendance_list_item.dart';
import 'package:training_organizer/features/edit/drop_down.dart';
import 'package:training_organizer/features/overview/button_row.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_cubit.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_state.dart';
import 'package:training_organizer/features/overview/trainees_cubit.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/import_export/ui/file_cubit.dart';
import 'package:training_organizer/import_export/ui/file_state.dart';
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
                        ],
                      ),
                    ),
                    const AttendanceListHeader(),
                    Expanded(
                      child: BlocBuilder<FilterTraineesCubit,
                          FilterTraineesState>(
                        builder: (context, filterState) {
                          return BlocBuilder<AttendanceCubit, AttendanceState>(
                            builder: (context, attendanceState) {
                              final trainees = filterState.selectedTrainees;
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
      ),
    );
  }
}

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

class AttendanceListHeader extends StatelessWidget {
  const AttendanceListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              'Anwesend',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              'Anzahl',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceButtonRow extends StatelessWidget {
  const AttendanceButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileCubit, FileState>(
      listenWhen: (previous, current) {
        return previous.exportState != current.exportState ||
            previous.errorMessage != current.errorMessage;
      },
      listener: (context, state) {
        if (state.exportState == ExportState.exportSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export successful')),
          );
        }
        if (state.exportState == ExportState.exportFailed &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade100,
              leading: const Icon(Icons.error_outline, color: Colors.red),
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          );
        }
        if (state.errorMessage != null &&
            state.exportState == ExportState.none) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red.shade100,
              leading: const Icon(Icons.error_outline, color: Colors.red),
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          );
        }
      },
      child: Align(
        alignment: Alignment.bottomRight,
        child: _AttendanceButtonContainer(),
      ),
    );
  }
}

class _AttendanceButtonContainer extends StatelessWidget {
  bool _isMobileLayout(BuildContext context) {
    final data = MediaQueryData.fromView(View.of(context));
    return data.size.shortestSide < 700;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobileLayout(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ImportButton(isMobile: isMobile),
        const SizedBox(width: 5),
        ExportButton(isMobile: isMobile),
        const SizedBox(width: 5),
      ],
    );
  }
}
