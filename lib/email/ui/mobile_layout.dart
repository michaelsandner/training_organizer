import 'package:flutter/material.dart';
import 'package:training_organizer/email/ui/saturday_group.dart';
import 'package:training_organizer/email/ui/trainer_group.dart';
import 'package:training_organizer/email/ui/waitinglist_group.dart';
import 'package:training_organizer/email/ui/wednesday_group.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SaturdayGroupWidget(),
        SizedBox(height: 16),
        WednesdayGroupWidget(),
        SizedBox(height: 16),
        TrainerGroupWidget(),
        SizedBox(height: 16),
        WaitinglistGroupWidget(),
      ],
    );
  }
}
