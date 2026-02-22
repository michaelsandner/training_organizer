import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/import_export/ui/file_cubit.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/rescue_qualification/ui/rescue_qualification_cubit.dart';
import 'package:training_organizer/rescue_qualification/ui/rescue_qualification_list_item.dart';
import 'package:training_organizer/rescue_qualification/ui/rescue_qualification_state.dart';

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
        final allTrainees = context.watch<AppCubit>().state.trainees;
        final filtered =
            _filterTrainees(allTrainees, rescueState.selectedFilter);
        final cubit = context.read<RescueQualificationCubit>();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ToggleButtons(
                isSelected: [
                  rescueState.selectedFilter == FilterableGroup.wednesday,
                  rescueState.selectedFilter == FilterableGroup.active,
                ],
                onPressed: (index) {
                  cubit.setFilter(index == 0
                      ? FilterableGroup.wednesday
                      : FilterableGroup.active);
                },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Mittwoch'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Aktiv'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ToggleButtons(
                isSelected: [
                  rescueState.selectedQualification ==
                      RescueQualificationType.bronze,
                  rescueState.selectedQualification ==
                      RescueQualificationType.silber,
                  rescueState.selectedQualification ==
                      RescueQualificationType.gold,
                ],
                onPressed: (index) {
                  cubit.setQualification(RescueQualificationType.values[index]);
                },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Bronze'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Silber'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Gold'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
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
