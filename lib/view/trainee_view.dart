import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/view/trainee_list.dart';

class TraineeView extends StatelessWidget {
  const TraineeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImportButton(),
              if (!kIsWeb) ExportButton(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SelectedCount(),
              DropDown(),
            ],
          ),
          Expanded(child: TraineeList()),
        ],
      ),
    );
  }
}

class SelectedCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
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

class ImportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return ElevatedButton(
      onPressed: () => cubit.loadFile(),
      child: const Text('Import'),
    );
  }
}

class ExportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return ElevatedButton(
      onPressed: () => cubit.saveFile(),
      child: const Text('Export'),
    );
  }
}

class DropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return DropdownButton<Group>(
            value: state.selectedGroup,
            items: Group.values
                .map<DropdownMenuItem<Group>>((Group value) =>
                    DropdownMenuItem(value: value, child: Text(value.name)))
                .toList(),
            onChanged: (Group? value) => cubit.setSelectedGroup(value));
      },
    );
  }
}