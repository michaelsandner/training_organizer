import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/email/ui/email_cubit.dart';

class SendButton extends StatelessWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCubit = context.read<EmailCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          final trainees = context.read<AppCubit>().state.trainees;
          emailCubit.sendEmail(trainees);
        },
        icon: const Icon(Icons.send, size: 24),
        label: const Text(
          'E-Mail senden',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          minimumSize: const Size(200, 56),
        ),
      ),
    );
  }
}
