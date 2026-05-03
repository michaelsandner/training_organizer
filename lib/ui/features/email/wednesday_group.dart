import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';
import 'package:training_organizer/ui/features/email/email_cubit.dart';
import 'package:training_organizer/ui/features/email/email_list_tile.dart';
import 'package:training_organizer/ui/features/email/email_state.dart';
import 'package:training_organizer/ui/features/email/group_header.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';

class WednesdayGroupWidget extends StatelessWidget {
  const WednesdayGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, emailState) {
        return BlocBuilder<TraineesCubit, TraineesState>(
          builder: (context, traineesState) {
            final emailCubit = context.read<EmailCubit>();
            final trainees = traineesState.trainees;

            final hasWednesday = TraineesFilterService.getTraineesOfGroup(
                    trainees, Group.wednesday)
                .isNotEmpty;
            final hasActive = TraineesFilterService.getTraineesOfGroup(
                    trainees, Group.active)
                .isNotEmpty;
            final hasLeisure = TraineesFilterService.getTraineesOfGroup(
                    trainees, Group.leisure)
                .isNotEmpty;

            return Column(
              children: [
                GroupHeader(
                  title: 'Mittwoch',
                  icon: Icons.calendar_today,
                  backgroundColor: Colors.green.shade50,
                  textColor: Colors.green.shade700,
                ),
                const SizedBox(height: 8),
                EmailListTile(
                  title: 'Alle',
                  group: null,
                  isSelected: _areAllWednesdaySelected(emailState),
                  isEnabled: hasWednesday,
                  onChanged: (selected) =>
                      emailCubit.selectAllWednesday(selected),
                ),
                EmailListTile(
                  title: 'Block 1 (Jugend I)',
                  group: EmailRecipientGroup.wednesdayBlock1,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.wednesdayBlock1,
                  ),
                  isEnabled: hasWednesday,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.wednesdayBlock1,
                    selected,
                  ),
                ),
                EmailListTile(
                  title: 'Block 2 (Jugend II)',
                  group: EmailRecipientGroup.wednesdayBlock2,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.wednesdayBlock2,
                  ),
                  isEnabled: hasWednesday,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.wednesdayBlock2,
                    selected,
                  ),
                ),
                EmailListTile(
                  title: 'Aktiv',
                  group: EmailRecipientGroup.active,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.active,
                  ),
                  isEnabled: hasActive,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.active,
                    selected,
                  ),
                ),
                EmailListTile(
                  title: 'Freizeit',
                  group: EmailRecipientGroup.leisure,
                  isSelected: emailState.isGroupSelected(
                    EmailRecipientGroup.leisure,
                  ),
                  isEnabled: hasLeisure,
                  onChanged: (selected) => emailCubit.toggleGroup(
                    EmailRecipientGroup.leisure,
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

  bool _areAllWednesdaySelected(EmailState state) {
    return state.isGroupSelected(EmailRecipientGroup.wednesdayBlock1) &&
        state.isGroupSelected(EmailRecipientGroup.wednesdayBlock2);
  }
}
