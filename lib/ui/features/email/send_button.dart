import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';
import 'package:training_organizer/ui/features/email/email_cubit.dart';
import 'package:training_organizer/ui/features/email/email_state.dart';

class SendButton extends StatelessWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TraineesCubit, TraineesState>(
      builder: (context, traineesState) {
        return BlocBuilder<EmailCubit, EmailState>(
          builder: (context, emailState) {
            final emailCubit = context.read<EmailCubit>();
            final hasTrainees = traineesState.trainees.isNotEmpty;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  if (!hasTrainees)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Keine E-Mail Adressen verfügbar. Bitte Mitglieder importieren.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: hasTrainees && emailState.hasSelection
                        ? () {
                            emailCubit.sendEmail(traineesState.trainees);
                          }
                        : null,
                    icon: const Icon(Icons.send, size: 24),
                    label: const Text(
                      'E-Mail senden',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      minimumSize: const Size(200, 56),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
