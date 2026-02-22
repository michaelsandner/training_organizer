import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/rescue_qualification/ui/rescue_qualification_cubit.dart';
import 'package:training_organizer/rescue_qualification/ui/rescue_qualification_state.dart';

class GroupFilterToggle extends StatelessWidget {
  const GroupFilterToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RescueQualificationCubit, RescueQualificationState>(
      builder: (context, state) {
        return ToggleButtons(
          isSelected: [
            state.selectedFilter == FilterableGroup.wednesday,
            state.selectedFilter == FilterableGroup.active,
          ],
          onPressed: (index) {
            context.read<RescueQualificationCubit>().setFilter(
                  index == 0
                      ? FilterableGroup.wednesday
                      : FilterableGroup.active,
                );
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
        );
      },
    );
  }
}

class QualificationToggle extends StatelessWidget {
  const QualificationToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RescueQualificationCubit, RescueQualificationState>(
      builder: (context, state) {
        return ToggleButtons(
          isSelected: [
            state.selectedQualification == RescueQualificationType.bronze,
            state.selectedQualification == RescueQualificationType.silber,
            state.selectedQualification == RescueQualificationType.gold,
          ],
          onPressed: (index) {
            context
                .read<RescueQualificationCubit>()
                .setQualification(RescueQualificationType.values[index]);
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
        );
      },
    );
  }
}
