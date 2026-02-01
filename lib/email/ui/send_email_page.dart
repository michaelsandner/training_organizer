import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/email/ui/email_cubit.dart';
import 'package:training_organizer/email/ui/email_state.dart';
import 'package:training_organizer/email/ui/header.dart';
import 'package:training_organizer/email/ui/saturday_group.dart';
import 'package:training_organizer/email/ui/send_button.dart';
import 'package:training_organizer/email/ui/trainer_group.dart';
import 'package:training_organizer/email/ui/waitinglist_group.dart';
import 'package:training_organizer/email/ui/wednesday_group.dart';

class SendEmailPage extends StatelessWidget {
  const SendEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailCubit, EmailState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 600;
            
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header
                const EmailPageHeader(),
                const SizedBox(height: 24),
                
                // Groups Layout
                if (isDesktop) ...[
                  // Desktop Layout: Saturday & Wednesday nebeneinander
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: SaturdayGroupWidget()),
                      SizedBox(width: 16),
                      Expanded(child: WednesdayGroupWidget()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Desktop Layout: Trainer & Waitinglist nebeneinander
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: TrainerGroupWidget()),
                      SizedBox(width: 16),
                      Expanded(child: WaitinglistGroupWidget()),
                    ],
                  ),
                ] else ...[
                  // Mobile Layout: Alle untereinander
                  const SaturdayGroupWidget(),
                  const SizedBox(height: 16),
                  const WednesdayGroupWidget(),
                  const SizedBox(height: 16),
                  const TrainerGroupWidget(),
                  const SizedBox(height: 16),
                  const WaitinglistGroupWidget(),
                ],
                
                const SizedBox(height: 24),
                const SendButton(),
              ],
            );
          },
        );
      },
    );
  }
}
