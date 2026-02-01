import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/import_export/ui/file_cubit.dart';
import 'package:training_organizer/import_export/ui/file_state.dart';
import 'package:training_organizer/services/platform_service.dart';
import 'package:training_organizer/view/trainee_view/button_row.dart';
import 'package:training_organizer/view/trainee_view/trainee_list.dart';

class TraineeView extends StatelessWidget {
  const TraineeView({super.key});

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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SelectedCount(),
                        DropDown(),
                      ],
                    ),
                  ),
                  state.showLoadingSpinner
                      ? const SizedBox(
                          width: 300,
                          height: 300,
                          child: LoadingIndicator(
                              indicatorType: Indicator.ballPulse,
                              colors: [Colors.blue],
                              strokeWidth: 2,
                              backgroundColor: Colors.white,
                              pathBackgroundColor: Colors.white),
                        )
                      : Expanded(child: TraineeList()),
                ],
              ),
              ButtonRow(),
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
