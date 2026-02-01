import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/email/ui/email_cubit.dart';
import 'package:training_organizer/email/ui/email_state.dart';

class SendEmailPage extends StatelessWidget {
  const SendEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, state) {
        final emailCubit = context.read<EmailCubit>();
        return ListView(
          children: [
            const Text(
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                'Email senden an:'),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('Samstag'),
                      EmailListTile(
                        title: 'Alle',
                        group: null,
                        isSelected: _areAllSaturdaySelected(state),
                        onChanged: (selected) =>
                            emailCubit.selectAllSaturday(selected),
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
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    const Text('Mittwoch'),
                    EmailListTile(
                      title: 'Alle',
                      group: null,
                      isSelected: _areAllWednesdaySelected(state),
                      onChanged: (selected) =>
                          emailCubit.selectAllWednesday(selected),
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
                ))
              ],
            ),
            const Divider(height: 32),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 45),
                TextButton(
                  onPressed: () {
                    final trainees = context.read<AppCubit>().state.trainees;
                    emailCubit.sendEmail(trainees);
                  },
                  child: const Text(style: TextStyle(fontSize: 20), 'Senden'),
                )
              ],
            )
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

  bool _areAllWednesdaySelected(EmailState state) {
    return state.isGroupSelected(EmailRecipientGroup.wednesdayBlock1) &&
        state.isGroupSelected(EmailRecipientGroup.wednesdayBlock2);
  }
}

class EmailListTile extends StatelessWidget {
  final String title;
  final EmailRecipientGroup? group;
  final bool isSelected;
  final Function(bool) onChanged;

  const EmailListTile({
    super.key,
    required this.isSelected,
    required this.title,
    required this.group,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      value: isSelected,
      onChanged: (bool? newValue) {
        onChanged(newValue ?? false);
      },
      dense: true,
    );
  }
}
