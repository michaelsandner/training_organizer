import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/services/platform_service.dart';

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
    final screenSize = MediaQuery.of(context).size;
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            columnWidths: const <int, TableColumnWidth>{
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(),
              2: IntrinsicColumnWidth(),
              3: FlexColumnWidth(),
              4: FlexColumnWidth(),
              5: FlexColumnWidth(),
              6: FlexColumnWidth(),
            },
            children:
                List<TableRow>.generate(state.selectedTrainees.length, (index) {
              final trainee = state.selectedTrainees[index];
              return TableRow(
                children: [
                  _EmailButton(
                    email: trainee.email,
                    foreName: trainee.forename,
                  ),
                  EditButton(
                    refresh: refresh,
                    trainee: trainee,
                  ),
                  UpAndDownButtons(refresh: refresh, trainee: trainee),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          if (state.selectedGroup == FilterableGroup.all &&
                              !isMobile(screenSize))
                            Text(trainee.groupShortName),
                          if (state.selectedGroup == FilterableGroup.all &&
                              !isMobile(screenSize))
                            const SizedBox(width: 10),
                          Text(
                            trainee.surname,
                            style: trainee.isMember
                                ? const TextStyle(color: Colors.black)
                                : const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            trainee.forename,
                            style: trainee.isMember
                                ? const TextStyle(color: Colors.black)
                                : const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isMobile(screenSize))
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(trainee.dateOfBirth),
                    ),
                  if (!isMobile(screenSize))
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(trainee.registrationDate),
                    ),
                  if (!isMobile(screenSize))
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(trainee.email),
                    ),
                  if (!isMobile(screenSize))
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(trainee.phone),
                    ),
                ],
              );
            }),
          ),
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

    return IconButton(
      onPressed: () => cubit.sendMail(email, foreName),
      icon: const Icon(Icons.mail),
      color: Colors.blue,
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
    return IconButton(
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
