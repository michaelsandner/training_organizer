import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/email/ui/email_cubit.dart';
import 'package:training_organizer/email/ui/email_list_tile.dart';
import 'package:training_organizer/email/ui/email_state.dart';
import 'package:training_organizer/email/ui/group_header.dart';

class WednesdayGroupWidget extends StatelessWidget {
  const WednesdayGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, state) {
        final emailCubit = context.read<EmailCubit>();

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
              isSelected: _areAllWednesdaySelected(state),
              onChanged: (selected) => emailCubit.selectAllWednesday(selected),
            ),
            EmailListTile(
              title: 'Block 1 (Jugend I)',
              group: EmailRecipientGroup.wednesdayBlock1,
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.wednesdayBlock1,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.wednesdayBlock1,
                selected,
              ),
            ),
            EmailListTile(
              title: 'Block 2 (Jugend II)',
              group: EmailRecipientGroup.wednesdayBlock2,
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.wednesdayBlock2,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.wednesdayBlock2,
                selected,
              ),
            ),
            EmailListTile(
              title: 'Aktiv',
              group: EmailRecipientGroup.active,
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.active,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.active,
                selected,
              ),
            ),
            EmailListTile(
              title: 'Freizeit',
              group: EmailRecipientGroup.leisure,
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.leisure,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.leisure,
                selected,
              ),
            ),
          ],
        );
      },
    );
  }

  bool _areAllWednesdaySelected(EmailState state) {
    return state.isGroupSelected(EmailRecipientGroup.wednesdayBlock1) &&
        state.isGroupSelected(EmailRecipientGroup.wednesdayBlock2);
  }
}
