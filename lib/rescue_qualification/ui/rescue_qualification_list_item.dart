import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/overview/qualifications.dart';
import 'package:training_organizer/rescue_qualification/ui/rescue_qualification_cubit.dart';
import 'package:training_organizer/rescue_qualification/ui/rescue_qualification_state.dart';

class RescueQualificationListItem extends StatelessWidget {
  final Trainee trainee;

  const RescueQualificationListItem({
    super.key,
    required this.trainee,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RescueQualificationCubit, RescueQualificationState>(
      builder: (context, state) {
        final isSelected = state.selectedTrainees.contains(trainee);
        return SizedBox(
          height: 48,
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) => context
                    .read<RescueQualificationCubit>()
                    .toggleTraineeSelection(trainee),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '${trainee.surname}, ${trainee.forename}',
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Qualifications(trainee: trainee),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
