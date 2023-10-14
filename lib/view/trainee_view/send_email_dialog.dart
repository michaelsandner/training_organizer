import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/email_cubit.dart';
import 'package:training_organizer/cubit/email_state.dart';

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
                const Column(
                  children: [
                    EmailListTile(
                      title: 'Kinder Samstag',
                      emailList: EmailList.saturdayKids,
                    ),
                    EmailListTile(
                      title: 'Kinder Samstag & Trainer',
                      emailList: EmailList.saturdayKidsAndTrainer,
                    ),
                    EmailListTile(
                      title: 'Kinder Mittwoch',
                      emailList: EmailList.wednesdayKids,
                    ),
                    EmailListTile(
                      title: 'Alle Kinder (Mi + Sa)',
                      emailList: EmailList.allKids,
                    ),
                    EmailListTile(
                      title: 'Aktive Erwachsene',
                      emailList: EmailList.active,
                    ),
                    EmailListTile(
                      title: 'Trainer',
                      emailList: EmailList.trainer,
                    ),
                    EmailListTile(
                      title: 'Eingeladen',
                      emailList: EmailList.invited,
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
  final EmailList emailList;

  const EmailListTile({
    required this.emailList,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    final emailCubit = context.read<EmailCubit>();
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, state) {
        return RadioListTile<EmailList>(
          title: Text(title),
          contentPadding: const EdgeInsets.symmetric(horizontal: 50),
          value: emailList,
          groupValue: state.emailList,
          onChanged: (value) => emailCubit.setEmailList(value),
        );
      },
    );
  }
}
