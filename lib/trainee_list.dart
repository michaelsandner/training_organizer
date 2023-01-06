import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/app_cubit.dart';
import 'package:training_organizer/app_state.dart';

class TraineeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();

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
                SizedBox(
                  width: 30,
                  child: Text(trainee.groupShortName),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(trainee.forename),
                      const SizedBox(width: 10),
                      Text(trainee.surname),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: IconButton(
                    onPressed: cubit.isUpgradePossible(trainee)
                        ? () => cubit.upgradeTrainee(trainee)
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
                          ? () => cubit.downgradeTrainee(trainee)
                          : null,
                      icon: const Icon(Icons.upgrade_sharp),
                      color: Colors.red,
                    ),
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