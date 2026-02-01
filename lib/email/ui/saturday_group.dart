import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/email/ui/email_cubit.dart';
import 'package:training_organizer/email/ui/email_list_tile.dart';
import 'package:training_organizer/email/ui/email_state.dart';
import 'package:training_organizer/email/ui/group_header.dart';

class SaturdayGroupWidget extends StatelessWidget {
  const SaturdayGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, state) {
        final emailCubit = context.read<EmailCubit>();

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
              isSelected: _areAllSaturdaySelected(state),
              onChanged: (selected) => emailCubit.selectAllSaturday(selected),
            ),
            EmailListTile(
              title: 'Block 5 (Pipsy)',
              group: EmailRecipientGroup.saturdayBlock5,
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.saturdayBlock5,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.saturdayBlock5,
                selected,
              ),
            ),
            EmailListTile(
              title: 'Block 1 (Elli)',
              group: EmailRecipientGroup.saturdayBlock1,
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.saturdayBlock1,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.saturdayBlock1,
                selected,
              ),
            ),
            EmailListTile(
              title: 'Block 2 (Eddie)',
              group: EmailRecipientGroup.saturdayBlock2,
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.saturdayBlock2,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.saturdayBlock2,
                selected,
              ),
            ),
            EmailListTile(
              title: 'Samstag: Block 4 (Ebbi)',
              group: EmailRecipientGroup.saturdayBlock4,
              isSelected: state.isGroupSelected(
                EmailRecipientGroup.saturdayBlock4,
              ),
              onChanged: (selected) => emailCubit.toggleGroup(
                EmailRecipientGroup.saturdayBlock4,
                selected,
              ),
            ),
          ],
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
