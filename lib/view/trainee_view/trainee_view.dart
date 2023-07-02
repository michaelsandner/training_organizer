import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/cubit/file_cubit.dart';
import 'package:training_organizer/cubit/file_state.dart';
import 'package:training_organizer/services/platform_service.dart';
import 'package:training_organizer/view/edit_view/add_trainee.dart';
import 'package:training_organizer/view/import_view.dart';
import 'package:training_organizer/view/trainee_view/trainee_list.dart';

class TraineeView extends StatelessWidget {
  const TraineeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocBuilder<FileCubit, FileState>(
      builder: (context, state) {
        return Padding(
          padding: isMobile(screenSize)
              ? const EdgeInsets.all(5)
              : const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                children: [
                  const ImportView(),
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
                  if (state.showLoadingSpinner)
                    const SizedBox(
                      width: 100,
                      height: 100,
                      child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: [Colors.blue],
                          strokeWidth: 2,
                          backgroundColor: Colors.white,
                          pathBackgroundColor: Colors.white),
                    ),
                  Expanded(child: TraineeList()),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: AddButton(),
              ),
            ],
          ),
        );
      },
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

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AddTrainee())),
      child: const Icon(Icons.add),
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
                        child: Text(cubit.getNameForFilteredGroupEnum(value))))
                .toList(),
            onChanged: (FilterableGroup? value) =>
                cubit.setSelectedGroup(value));
      },
    );
  }
}
