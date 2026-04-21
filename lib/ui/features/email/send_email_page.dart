import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/email/desktop_layout.dart';
import 'package:training_organizer/ui/features/email/email_cubit.dart';
import 'package:training_organizer/ui/features/email/email_state.dart';
import 'package:training_organizer/ui/features/email/header.dart';
import 'package:training_organizer/ui/features/email/mobile_layout.dart';
import 'package:training_organizer/ui/features/email/send_button.dart';

class SendEmailPage extends StatelessWidget {
  const SendEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email'),
      ),
      body: BlocBuilder<EmailCubit, EmailState>(
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
      ),
    );
  }
}
