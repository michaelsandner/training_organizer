import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/services/platform_service.dart';
import 'package:training_organizer/view/edit_view/add_trainee.dart';

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
                  _EmailButton(trainee: trainee),
                  EditButton(
                    refresh: refresh,
                    trainee: trainee,
                  ),
                  UpAndDownButtons(refresh: refresh, trainee: trainee),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Ausbildungen'),
                                content: SizedBox(
                                  height: 200,
                                  child: Column(
                                    children: List.generate(
                                        trainee.badges.length, (index) {
                                      final currentBadge =
                                          trainee.badges[index];
                                      if (currentBadge != null) {
                                        return Row(
                                          children: [
                                            currentBadge.icon,
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (currentBadge.date != null)
                                              Text(currentBadge.date!.year
                                                  .toString()),
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
                            if (trainee.comment != "")
                              Tooltip(
                                message: trainee.comment,
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Icon(
                                    Icons.warning,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isMobile(screenSize))
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
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
  final Trainee trainee;
  const _EmailButton({
    required this.trainee,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();

    return IconButton(
      onPressed: () => cubit.sendMailToTrainee(trainee),
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
    return IconButton(
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
