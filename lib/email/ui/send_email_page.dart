import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/email/ui/desktop_layout.dart';
import 'package:training_organizer/email/ui/email_cubit.dart';
import 'package:training_organizer/email/ui/email_state.dart';
import 'package:training_organizer/email/ui/header.dart';
import 'package:training_organizer/email/ui/mobile_layout.dart';
import 'package:training_organizer/email/ui/send_button.dart';

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
                if (isDesktop)
                  const DesktopLayout()
                else
                  const MobileLayout(),

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
