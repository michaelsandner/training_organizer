import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/services/platform_service.dart';
import 'package:training_organizer/view/trainee_list.dart';

class TraineeView extends StatelessWidget {
  const TraineeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: isMobile(screenSize)
          ? const EdgeInsets.all(5)
          : const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImportButton(),
              if (!kIsWeb) ExportButton(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SelectedCount(),
                const _EmailButtonGoup(),
                const _EmailButtonSaturday(),
                DropDown(),
              ],
            ),
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

class _EmailButtonGoup extends StatelessWidget {
  const _EmailButtonGoup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();

    return Column(
      children: [
        IconButton(
          onPressed: () => cubit.sendMailToSelectedGroup(),
          icon: const Icon(Icons.mail),
          color: Colors.blue,
        ),
        const Text('Gruppe'),
      ],
    );
  }
}

class _EmailButtonSaturday extends StatelessWidget {
  const _EmailButtonSaturday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();

    return Column(
      children: [
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: const Text('Möchtest du die Trainer in cc setzen?'),
              children: <Widget>[
                SimpleDialogOption(
                  child: const Text('Ja'),
                  onPressed: () => cubit.sendMailToSaturdayTrainees(true),
                ),
                SimpleDialogOption(
                  child: const Text('Nein'),
                  onPressed: () => cubit.sendMailToSaturdayTrainees(false),
                )
              ],
            ),
          ),
          icon: const Icon(Icons.mail),
          color: Colors.blue,
        ),
        const Text('Samstag'),
      ],
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
        return DropdownButton<FilterableGroup>(
            value: state.selectedGroup,
            items: FilterableGroup.values
                .map<DropdownMenuItem<FilterableGroup>>(
                    (FilterableGroup value) => DropdownMenuItem(
                        value: value,
                        child: Text(cubit.getNameForFilteredGroupEnum(value))))
                .toList(),
            onChanged: (FilterableGroup? value) =>
                cubit.setSelectedGroup(value));
      },
    );
  }
}
