import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/overview/selection/selection_cubit.dart';

class EmailButton extends StatelessWidget {
  final Trainee trainee;
  const EmailButton({
    required this.trainee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    final selectedGroup = context.read<SelectionCubit>().state.selectedGroup;

    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () => cubit.sendMailToTrainee(trainee, selectedGroup),
      icon: const Icon(Icons.mail),
      color: Colors.blue,
    );
  }
}
