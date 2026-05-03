import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';
import 'package:training_organizer/ui/features/email/email_cubit.dart';
import 'package:training_organizer/ui/features/email/email_list_tile.dart';
import 'package:training_organizer/ui/features/email/email_state.dart';
import 'package:training_organizer/ui/features/email/group_header.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';

class WaitinglistGroupWidget extends StatelessWidget {
  const WaitinglistGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, emailState) {
        return BlocBuilder<TraineesCubit, TraineesState>(
          builder: (context, traineesState) {
            final emailCubit = context.read<EmailCubit>();
            final trainees = traineesState.trainees;

            final hasWaitingList = TraineesFilterService.getTraineesOfGroup(
                    trainees, Group.waitingList)
                .isNotEmpty;
            final hasInvited = TraineesFilterService.getTraineesOfGroup(
                    trainees, Group.invited)
                .isNotEmpty;

            return Column(
              children: [
                GroupHeader(
                  title: 'Warteliste',
                  icon: Icons.hourglass_bottom,
                  backgroundColor: Colors.orange.shade50,
                  textColor: Colors.orange.shade700,
                ),
                const SizedBox(height: 8),
                EmailListTile(
                  title: 'Warteliste',
                  group: EmailRecipientGroup.waitinglist,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.waitinglist,
                  ),
                  isEnabled: hasWaitingList,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.waitinglist,
                    selected,
                  ),
                ),
                EmailListTile(
                  title: 'Eingeladen zum Training',
                  group: EmailRecipientGroup.invited,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.invited,
                  ),
                  isEnabled: hasInvited,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.invited,
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
