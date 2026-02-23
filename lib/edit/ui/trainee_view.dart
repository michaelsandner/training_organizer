import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:training_organizer/edit/ui/drop_down.dart';
import 'package:training_organizer/edit/ui/selected_count.dart';
import 'package:training_organizer/import_export/ui/file_cubit.dart';
import 'package:training_organizer/import_export/ui/file_state.dart';
import 'package:training_organizer/overview/button_row.dart';
import 'package:training_organizer/overview/trainee_list.dart';
import 'package:training_organizer/services/platform_service.dart';

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
