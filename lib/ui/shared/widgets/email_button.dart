import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/email/email_cubit.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/ui/features/overview/selection/filter_trainees_cubit.dart';

class EmailButton extends StatelessWidget {
  final Trainee trainee;
  const EmailButton({
    required this.trainee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final emailCubit = context.read<EmailCubit>();
    final selectedGroup =
        context.read<FilterTraineesCubit>().state.selectedGroup;

    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () => emailCubit.sendMailToTrainee(trainee, selectedGroup),
      icon: const Icon(Icons.mail),
      color: Colors.blue,
    );
  }
}
