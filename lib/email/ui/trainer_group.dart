import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/email/ui/email_cubit.dart';
import 'package:training_organizer/email/ui/email_list_tile.dart';
import 'package:training_organizer/email/ui/email_state.dart';
import 'package:training_organizer/email/ui/group_header.dart';

class TrainerGroupWidget extends StatelessWidget {
  const TrainerGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, state) {
        final emailCubit = context.read<EmailCubit>();

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
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.trainer,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.trainer,
                selected,
              ),
            ),
          ],
        );
      },
    );
  }
}
