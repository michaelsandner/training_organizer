import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';
import 'package:training_organizer/ui/features/email/email_cubit.dart';
import 'package:training_organizer/ui/features/email/email_list_tile.dart';
import 'package:training_organizer/ui/features/email/email_state.dart';
import 'package:training_organizer/ui/features/email/group_header.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';

class TrainerGroupWidget extends StatelessWidget {
  const TrainerGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, emailState) {
        return BlocBuilder<TraineesCubit, TraineesState>(
          builder: (context, traineesState) {
            final emailCubit = context.read<EmailCubit>();
            final trainees = traineesState.trainees;

            final hasTrainers =
                TraineesFilterService.getAllTrainers(trainees).isNotEmpty;

            return Column(
              children: [
                GroupHeader(
                  title: 'Trainer',
                  icon: Icons.sports,
                  backgroundColor: Colors.purple.shade50,
                  textColor: Colors.purple.shade700,
                ),
                const SizedBox(height: 8),
                EmailListTile(
                  title: 'Trainer',
                  group: EmailRecipientGroup.trainer,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.trainer,
                  ),
                  isEnabled: hasTrainers,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.trainer,
                    selected,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
