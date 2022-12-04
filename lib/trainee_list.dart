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
            return ListTile(
                title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(state.selectedTrainees[index].groupShortName),
                Text(state.selectedTrainees[index].forename),
                Text(state.selectedTrainees[index].surname),
                IconButton(
                  onPressed: () =>
                      cubit.updateTrainee(state.selectedTrainees[index]),
                  icon: const Icon(Icons.upgrade_sharp),
                ),
              ],
            ));
          },
        );
      },
    );
  }
}
