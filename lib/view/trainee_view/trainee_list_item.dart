import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
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
                _BadgeOverlay(
                    trainee: trainee, child: _Badges(trainee: trainee)),
              ],
            ),
          )
        : SizedBox(
            height: 40,
            child: Row(
              children: [
                UpAndDownButtons(refresh: () => refresh, trainee: trainee),
                Expanded(
                  child: _BadgeOverlay(
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

class _BadgeOverlay extends StatelessWidget {
  final Trainee trainee;
  final Widget child;
  const _BadgeOverlay({
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
                  children: List.generate(trainee.badges.length, (index) {
                    final currentBadge = trainee.badges[index];
                    if (currentBadge != null) {
                      return Row(
                        children: [
                          currentBadge.icon,
                          const SizedBox(
                            width: 10,
                          ),
                          if (currentBadge.date != null)
                            Text(currentBadge.date!.year.toString()),
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

class _Badges extends StatelessWidget {
  final Trainee trainee;
  const _Badges({
    required this.trainee,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: List.generate(trainee.badges.length, (index) {
          final currentBadge = trainee.badges[index];
          if (currentBadge != null) {
            return Tooltip(
              message: currentBadge.date == null
                  ? '${currentBadge.fullName} \n Datum: - '
                  : '${currentBadge.fullName} \n Datum: ${currentBadge.date!.year.toString()}',
              child: currentBadge.icon,
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
