import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/services/platform_service.dart';
import 'package:training_organizer/view/trainee_view/trainee_list_item.dart';

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
          itemCount: state.selectedTrainees.length,
          itemBuilder: (BuildContext context, int index) {
            return TraineeListItem(
              trainee: state.selectedTrainees[index],
              refresh: refresh,
              isLargeView: !isMobile(screenSize),
            );
          },
        );
      },
    );
  }
}
