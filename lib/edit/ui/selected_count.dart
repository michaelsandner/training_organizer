import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/overview/selection/selection_cubit.dart';
import 'package:training_organizer/overview/selection/selection_state.dart';

class SelectedCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) {
        final count = state.selectedTrainees.length;
        return SizedBox(
          width: 100,
          child: Text(
            'Count: $count',
            style: const TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}
