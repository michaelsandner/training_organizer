import 'package:flutter/material.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/overview/edit_button.dart';
import 'package:training_organizer/overview/item_text_box.dart';
import 'package:training_organizer/overview/qualification_overlay.dart';
import 'package:training_organizer/overview/qualifications.dart';
import 'package:training_organizer/overview/up_and_down_buttons.dart';

class TraineeListItem extends StatelessWidget {
  final Trainee trainee;
  final Function refresh;
  final bool isLargeView;
  const TraineeListItem({
    required this.trainee,
    required this.refresh,
    this.isLargeView = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return isLargeView
        ? SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UpAndDownButtons(refresh: () => refresh, trainee: trainee),
                ItemTextBox(
                  text: '${trainee.surname} ${trainee.forename}',
                  isMember: trainee.isMember,
                  width: 200,
                ),
                ItemTextBox(
                  text: trainee.dateOfBirth,
                  isMember: trainee.isMember,
                  width: 120,
                ),
                EditButton(trainee: trainee),
                QualificationOverlay(
                  trainee: trainee,
                  child: Qualifications(trainee: trainee),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 40,
            child: Row(
              children: [
                UpAndDownButtons(refresh: () => refresh, trainee: trainee),
                Expanded(
                  child: QualificationOverlay(
                    trainee: trainee,
                    child: ItemTextBox(
                      text: '${trainee.forename} ${trainee.surname}',
                      isMember: trainee.isMember,
                    ),
                  ),
                ),
                EditButton(trainee: trainee),
              ],
            ),
          );
  }
}
