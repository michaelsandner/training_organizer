import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/overview/trainee_list_item.dart';
import 'package:training_organizer/services/platform_service.dart';

class TraineeList extends StatefulWidget {
  @override
  State<TraineeList> createState() => _TraineeListState();
}

class _TraineeListState extends State<TraineeList> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 50),
          itemCount: state.selectedTrainees.length,
          itemExtent: 40, // Fixed height improves performance
          itemBuilder: (BuildContext context, int index) {
            final trainee = state.selectedTrainees[index];
            return RepaintBoundary(
              key: ValueKey('${trainee.surname}_${trainee.forename}_$index'),
              child: TraineeListItem(
                trainee: trainee,
                refresh: refresh,
                isLargeView: !isMobile(screenSize),
              ),
            );
          },
        );
      },
    );
  }
}
