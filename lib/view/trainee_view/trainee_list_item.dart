import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/model/qualification_type.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/view/edit_view/add_trainee.dart';

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
                  text: '${trainee.forename} ${trainee.surname}',
                  isMember: trainee.isMember,
                  width: 200,
                ),
                ItemTextBox(
                  text: trainee.dateOfBirth,
                  isMember: trainee.isMember,
                  width: 120,
                ),
                EditButton(trainee: trainee),
                _EmailButton(trainee: trainee),
                _QualificationOverlay(
                    trainee: trainee, child: _Qualifications(trainee: trainee)),
              ],
            ),
          )
        : SizedBox(
            height: 40,
            child: Row(
              children: [
                UpAndDownButtons(refresh: () => refresh, trainee: trainee),
                Expanded(
                  child: _QualificationOverlay(
                    trainee: trainee,
                    child: ItemTextBox(
                      text: '${trainee.forename} ${trainee.surname}',
                      isMember: trainee.isMember,
                    ),
                  ),
                ),
                EditButton(trainee: trainee),
                _EmailButton(trainee: trainee),
              ],
            ),
          );
  }
}

class _QualificationOverlay extends StatelessWidget {
  final Trainee trainee;
  final Widget child;
  const _QualificationOverlay({
    required this.child,
    required this.trainee,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ausbildungen'),
              content: SizedBox(
                height: 200,
                child: Column(
                  children:
                      List.generate(trainee.qualifications.length, (index) {
                    final currentqualification = trainee.qualifications[index];
                    if (currentqualification != null) {
                      return Row(
                        children: [
                          currentqualification.qualificationType.icon,
                          const SizedBox(
                            width: 10,
                          ),
                          if (currentqualification.date != null)
                            Text(currentqualification.date!.year.toString()),
                        ],
                      );
                    } else {
                      return const Icon(
                        Icons.warning,
                        color: Colors.red,
                      );
                    }
                  }),
                ),
              ),
            );
          }),
      child: child,
    );
  }
}

class _Qualifications extends StatelessWidget {
  final Trainee trainee;
  const _Qualifications({
    required this.trainee,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: List.generate(trainee.qualifications.length, (index) {
          final currentqualification = trainee.qualifications[index];
          if (currentqualification != null) {
            return Tooltip(
              message: currentqualification.date == null
                  ? '${currentqualification.qualificationType.fullName} \n Datum: - '
                  : '${currentqualification.qualificationType.fullName} \n Datum: ${currentqualification.date!.year.toString()}',
              child: currentqualification.qualificationType.icon,
            );
          } else {
            return const Icon(
              Icons.warning,
              color: Colors.red,
            );
          }
        }),
      ),
    );
  }
}

class ItemTextBox extends StatelessWidget {
  final String text;
  final double? width;
  final bool isMember;
  const ItemTextBox({
    required this.text,
    this.width,
    required this.isMember,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      width: width,
      child: SelectableText(
        text,
        style: TextStyle(
            color: isMember ? Colors.black : Colors.red,
            fontStyle: !isMember ? FontStyle.italic : FontStyle.normal),
      ),
    );
  }
}

class _EmailButton extends StatelessWidget {
  final Trainee trainee;
  const _EmailButton({
    required this.trainee,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();

    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () => cubit.sendMailToTrainee(trainee),
      icon: const Icon(Icons.mail),
      color: Colors.blue,
    );
  }
}

class EditButton extends StatefulWidget {
  final Trainee trainee;

  const EditButton({required this.trainee});

  @override
  State<EditButton> createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    _emailController.text = widget.trainee.email;
    _phoneController.text = widget.trainee.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddTrainee(
                    trainee: widget.trainee,
                  ))),
      icon: const Icon(Icons.edit),
      color: Colors.orange,
    );
  }
}

class UpAndDownButtons extends StatelessWidget {
  final Function() refresh;
  final Trainee trainee;
  const UpAndDownButtons({
    required this.refresh,
    required this.trainee,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return Row(
      children: [
        IconButton(
          iconSize: 30,
          padding: const EdgeInsets.all(0),
          onPressed: cubit.isUpgradePossible(trainee)
              ? () {
                  cubit.upgradeTrainee(trainee);
                  refresh();
                }
              : null,
          icon: const Icon(Icons.upgrade_sharp),
          color: Colors.green,
        ),
        Transform.rotate(
          angle: pi,
          child: IconButton(
            iconSize: 30,
            padding: const EdgeInsets.all(0),
            onPressed: cubit.isDowngradePossible(trainee)
                ? () {
                    cubit.downgradeTrainee(trainee);
                    refresh();
                  }
                : null,
            icon: const Icon(Icons.upgrade_sharp),
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
