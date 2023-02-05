import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/app_cubit.dart';
import 'package:training_organizer/app_state.dart';
import 'package:training_organizer/trainee.dart';

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
