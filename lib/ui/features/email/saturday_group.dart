import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';
import 'package:training_organizer/ui/features/email/email_cubit.dart';
import 'package:training_organizer/ui/features/email/email_list_tile.dart';
import 'package:training_organizer/ui/features/email/email_state.dart';
import 'package:training_organizer/ui/features/email/group_header.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';

class SaturdayGroupWidget extends StatelessWidget {
  const SaturdayGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, emailState) {
        return BlocBuilder<TraineesCubit, TraineesState>(
          builder: (context, traineesState) {
            final emailCubit = context.read<EmailCubit>();
            final trainees = traineesState.trainees;

            final hasBlock5 = TraineesFilterService.getTraineesOfGroup(
                    trainees, Group.group5)
                .isNotEmpty;
            final hasBlock1 = TraineesFilterService.getTraineesOfGroup(
                    trainees, Group.group1)
                .isNotEmpty;
            final hasBlock2 = TraineesFilterService.getTraineesOfGroup(
                    trainees, Group.group2)
                .isNotEmpty;
            final hasBlock4 = TraineesFilterService.getTraineesOfGroup(
                    trainees, Group.group4)
                .isNotEmpty;
            final hasAnySaturday =
                hasBlock5 || hasBlock1 || hasBlock2 || hasBlock4;

            return Column(
              children: [
                GroupHeader(
                  title: 'Samstag',
                  icon: Icons.calendar_today,
                  backgroundColor: Colors.blue.shade50,
                  textColor: Colors.blue.shade700,
                ),
                const SizedBox(height: 8),
                EmailListTile(
                  title: 'Alle',
                  group: null,
                  isSelected: _areAllSaturdaySelected(emailState),
                  isEnabled: hasAnySaturday,
                  onChanged: (selected) =>
                      emailCubit.selectAllSaturday(selected),
                ),
                EmailListTile(
                  title: 'Block 5 (Pipsy)',
                  group: EmailRecipientGroup.saturdayBlock5,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.saturdayBlock5,
                  ),
                  isEnabled: hasBlock5,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.saturdayBlock5,
                    selected,
                  ),
                ),
                EmailListTile(
                  title: 'Block 1 (Elli)',
                  group: EmailRecipientGroup.saturdayBlock1,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.saturdayBlock1,
                  ),
                  isEnabled: hasBlock1,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.saturdayBlock1,
                    selected,
                  ),
                ),
                EmailListTile(
                  title: 'Block 2 (Eddie)',
                  group: EmailRecipientGroup.saturdayBlock2,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.saturdayBlock2,
                  ),
                  isEnabled: hasBlock2,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.saturdayBlock2,
                    selected,
                  ),
                ),
                EmailListTile(
                  title: 'Samstag: Block 4 (Ebbi)',
                  group: EmailRecipientGroup.saturdayBlock4,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.saturdayBlock4,
                  ),
                  isEnabled: hasBlock4,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.saturdayBlock4,
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

  bool _areAllSaturdaySelected(EmailState state) {
    return state.isGroupSelected(EmailRecipientGroup.saturdayBlock1) &&
        state.isGroupSelected(EmailRecipientGroup.saturdayBlock2) &&
        state.isGroupSelected(EmailRecipientGroup.saturdayBlock4) &&
        state.isGroupSelected(EmailRecipientGroup.saturdayBlock5);
  }
}
