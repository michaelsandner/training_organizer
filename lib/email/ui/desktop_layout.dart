import 'package:flutter/material.dart';
import 'package:training_organizer/email/ui/saturday_group.dart';
import 'package:training_organizer/email/ui/trainer_group.dart';
import 'package:training_organizer/email/ui/waitinglist_group.dart';
import 'package:training_organizer/email/ui/wednesday_group.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Saturday & Wednesday nebeneinander
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SaturdayGroupWidget()),
            SizedBox(width: 16),
            Expanded(child: WednesdayGroupWidget()),
          ],
        ),
        SizedBox(height: 16),
        // Trainer & Waitinglist nebeneinander
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: TrainerGroupWidget()),
            SizedBox(width: 16),
            Expanded(child: WaitinglistGroupWidget()),
          ],
        ),
      ],
    );
  }
}
