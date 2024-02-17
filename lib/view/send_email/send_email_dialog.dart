import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/view/send_email/email_cubit.dart';
import 'package:training_organizer/view/send_email/email_state.dart';

class SendEmailDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocBuilder<EmailCubit, EmailState>(
        builder: (context, state) {
          final emailCubit = context.read<EmailCubit>();
          return Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    'Email senden:'),
                Column(
                  children: [
                    EmailListTile(
                      title: 'Kinder Samstag',
                      value: state.shouldSendToSaturdayKids,
                      onChanged: emailCubit.shouldSendToSaturdayKids,
                    ),
                    EmailListTile(
                      title: 'Kinder Mittwoch',
                      value: state.shouldSendToWednesdayKids,
                      onChanged: emailCubit.shouldSendToWednesdayKids,
                    ),
                    EmailListTile(
                      title: 'Aktive Erwachsene',
                      value: state.shouldSendToActive,
                      onChanged: emailCubit.shouldSendToActive,
                    ),
                    EmailListTile(
                      title: 'Trainer',
                      value: state.shouldSendToTrainer,
                      onChanged: emailCubit.shouldSendToTrainer,
                    ),
                    EmailListTile(
                      title: 'Eingeladen',
                      value: state.shouldSendToInvited,
                      onChanged: emailCubit.shouldSendToInvited,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                          style: TextStyle(fontSize: 20), 'Abbrechen'),
                    ),
                    const SizedBox(width: 45),
                    TextButton(
                      onPressed: () {
                        final trainees =
                            context.read<AppCubit>().state.trainees;
                        emailCubit.sendEmail(trainees);
                      },
                      child:
                          const Text(style: TextStyle(fontSize: 20), 'Senden'),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class EmailListTile extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const EmailListTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, state) {
        return CheckboxListTile(
          title: Text(title),
          value: value,
          onChanged: (bool? newValue) {
            onChanged(newValue ?? false);
          },
        );
      },
    );
  }
}
