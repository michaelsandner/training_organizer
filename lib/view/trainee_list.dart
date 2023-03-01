import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';

class TraineeList extends StatefulWidget {
  @override
  State<TraineeList> createState() => _TraineeListState();
}

class _TraineeListState extends State<TraineeList> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.selectedTrainees.length,
          itemBuilder: (BuildContext context, int index) {
            final trainee = state.selectedTrainees[index];
            return ListTile(
                title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (state.selectedGroup == Group.all)
                  SizedBox(
                    width: 30,
                    child: Text(trainee.groupShortName),
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      UpAndDownButtons(refresh: refresh, trainee: trainee),
                      EditButton(
                        refresh: refresh,
                        trainee: trainee,
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(trainee.surname),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: Text(trainee.forename),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(trainee.phone),
                      _EmailButton(
                        email: trainee.email,
                        foreName: trainee.forename,
                      ),
                    ],
                  ),
                ),
              ],
            ));
          },
        );
      },
    );
  }
}

class _EmailButton extends StatelessWidget {
  final String email;
  final String foreName;
  const _EmailButton({
    required this.email,
    required this.foreName,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();

    return SizedBox(
      width: 30,
      child: IconButton(
        onPressed: () => cubit.sendMail(email, foreName),
        icon: const Icon(Icons.mail),
        color: Colors.yellow,
      ),
    );
  }
}

class EditButton extends StatefulWidget {
  final Trainee trainee;
  final Function() refresh;
  const EditButton({required this.trainee, required this.refresh});

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
    final cubit = context.read<AppCubit>();
    return SizedBox(
      width: 30,
      child: IconButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Edit'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(hintText: 'Phone'),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    child: const Text('Abbrechen'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    child: const Text('Speichern'),
                    onPressed: () {
                      cubit.editTrainee(widget.trainee, _phoneController.text,
                          _emailController.text);
                      Navigator.pop(context);
                      widget.refresh();
                    },
                  ),
                ],
              );
            }),
        icon: const Icon(Icons.edit),
        color: Colors.orange,
      ),
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
        SizedBox(
          width: 30,
          child: IconButton(
            onPressed: cubit.isUpgradePossible(trainee)
                ? () {
                    cubit.upgradeTrainee(trainee);
                    refresh();
                  }
                : null,
            icon: const Icon(Icons.upgrade_sharp),
            color: Colors.green,
          ),
        ),
        SizedBox(
          width: 40,
          child: Transform.rotate(
            angle: pi,
            child: IconButton(
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
        ),
      ],
    );
  }
}
