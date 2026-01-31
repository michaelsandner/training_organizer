import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/email/email_cubit.dart';
import 'package:training_organizer/email/email_state.dart';

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
                        value: state.shouldSendToAllSaturday,
                        onChanged: emailCubit.shouldSendToAllSaturday,
                      ),
                      EmailListTile(
                        title: 'Block 5 (Pipsy)',
                        value: state.shouldSendToSaturdayBlock5,
                        onChanged: emailCubit.shouldSendToSaturdayBlock5,
                      ),
                      EmailListTile(
                        title: 'Block 1 (Elli)',
                        value: state.shouldSendToSaturdayBlock1,
                        onChanged: emailCubit.shouldSendToSaturdayBlock1,
                      ),
                      EmailListTile(
                        title: 'Block 2 (Eddie)',
                        value: state.shouldSendToSaturdayBlock2,
                        onChanged: emailCubit.shouldSendToSaturdayBlock2,
                      ),
                      EmailListTile(
                        title: 'Samstag: Block 4 (Ebbi)',
                        value: state.shouldSendToSaturdayBlock4,
                        onChanged: emailCubit.shouldSendToSaturdayBlock4,
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
                      value: state.shouldSendToAllWednesday,
                      onChanged: emailCubit.shouldSendToAllWednesday,
                    ),
                    EmailListTile(
                      title: 'Block 1 (Jugend I)',
                      value: state.shouldSendToWednesdayBlock1,
                      onChanged: emailCubit.shouldSendToWednesdayBlock1,
                    ),
                    EmailListTile(
                      title: 'Block 2 (Jugend II)',
                      value: state.shouldSendToWednesdayBlock2,
                      onChanged: emailCubit.shouldSendToWednesdayBlock2,
                    ),
                    EmailListTile(
                      title: 'Aktiv',
                      value: state.shouldSendToActive,
                      onChanged: emailCubit.shouldSendToActive,
                    ),
                    EmailListTile(
                      title: 'Freizeit',
                      value: state.shouldSendToLeisure,
                      onChanged: emailCubit.shouldSendToLeisure,
                    ),
                  ],
                ))
              ],
            ),
            EmailListTile(
              title: 'Trainer',
              value: state.shouldSendToTrainer,
              onChanged: emailCubit.shouldSendToTrainer,
            ),
            EmailListTile(
              title: 'Warteliste',
              value: state.shouldSendToWaitinglist,
              onChanged: emailCubit.shouldSendToWaitinglist,
            ),
            EmailListTile(
              title: 'Eingeladen zum Training',
              value: state.shouldSendToInvited,
              onChanged: emailCubit.shouldSendToInvited,
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
        return Material(
          child: CheckboxListTile(
            title: Text(title),
            value: value,
            onChanged: (bool? newValue) {
              onChanged(newValue ?? false);
            },
          ),
        );
      },
    );
  }
}
