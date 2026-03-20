import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/overview/selection/selection_cubit.dart';
import 'package:training_organizer/overview/selection/selection_state.dart';

class DropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectionCubit = context.read<SelectionCubit>();
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) {
        return DropdownButton<FilterableGroup>(
            focusColor: Colors.white,
            elevation: 15,
            icon: const Icon(Icons.arrow_downward),
            underline: Container(
              height: 2,
              color: Colors.blue,
            ),
            value: state.selectedGroup,
            items: FilterableGroup.values
                .map<DropdownMenuItem<FilterableGroup>>(
                    (FilterableGroup value) => DropdownMenuItem(
                        value: value,
                        child: Text(
                            selectionCubit.getNameForFilteredGroupEnum(value))))
                .toList(),
            onChanged: (FilterableGroup? value) => selectionCubit
                .setSelectedGroup(value, context.read<AppCubit>().state.trainees));
      },
    );
  }
}
