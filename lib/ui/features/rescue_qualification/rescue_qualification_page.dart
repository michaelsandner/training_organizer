import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';
import 'package:training_organizer/ui/features/import_export/file_cubit.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/ui/features/rescue_qualification/rescue_qualification_cubit.dart';
import 'package:training_organizer/ui/features/rescue_qualification/rescue_qualification_info_box.dart';
import 'package:training_organizer/ui/features/rescue_qualification/rescue_qualification_list_item.dart';
import 'package:training_organizer/ui/features/rescue_qualification/rescue_qualification_state.dart';
import 'package:training_organizer/ui/features/rescue_qualification/rescue_qualification_toggles.dart';

class RescueQualificationPage extends StatelessWidget {
  const RescueQualificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RescueQualificationCubit(),
      child: BlocBuilder<RescueQualificationCubit, RescueQualificationState>(
        builder: (context, rescueState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Rettungsschwimmausbildung'),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: rescueState.selectedTrainees.isEmpty
                  ? null
                  : () => context
                      .read<FileCubit>()
                      .saveRescueCertificationAttendeesAsCsv(
                        rescueState.selectedTrainees.toList(),
                        rescueState.selectedQualification.name,
                      ),
              icon: const Icon(Icons.download),
              label: const Text('Exportieren'),
            ),
            body: const _RescueQualificationBody(),
          );
        },
      ),
    );
  }
}

class _RescueQualificationBody extends StatelessWidget {
  const _RescueQualificationBody();

  List<Trainee> _filterTrainees(
      List<Trainee> trainees, FilterableGroup filter) {
    final group =
        filter == FilterableGroup.wednesday ? Group.wednesday : Group.active;
    return trainees.where((t) => t.trainingGroup == group).toList()
      ..sort((a, b) => a.surname.compareTo(b.surname));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RescueQualificationCubit, RescueQualificationState>(
      builder: (context, rescueState) {
        final allTrainees = context.watch<TraineesCubit>().state.trainees;
        final filtered =
            _filterTrainees(allTrainees, rescueState.selectedFilter);

        return Column(
          children: [
            const RescueQualificationInfoBox(),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: GroupFilterToggle(),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: QualificationToggle(),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return RescueQualificationListItem(
                    trainee: filtered[index],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
