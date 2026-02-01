import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/email/ui/email_cubit.dart';
import 'package:training_organizer/email/ui/email_list_tile.dart';
import 'package:training_organizer/email/ui/email_state.dart';
import 'package:training_organizer/email/ui/group_header.dart';

class WaitinglistGroupWidget extends StatelessWidget {
  const WaitinglistGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, state) {
        final emailCubit = context.read<EmailCubit>();

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
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.waitinglist,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.waitinglist,
                selected,
              ),
            ),
            EmailListTile(
              title: 'Eingeladen zum Training',
              group: EmailRecipientGroup.invited,
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.invited,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.invited,
                selected,
              ),
            ),
          ],
        );
      },
    );
  }
}
