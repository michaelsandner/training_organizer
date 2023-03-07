import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/badge.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return ListView(
          children: [
            StatisticsItem(
              description: Wasserretter(null).fullName,
              count: state.trainees
                  .where((element) => element.hasBadge('Wasserretter'))
                  .length
                  .toString(),
            ),
            StatisticsItem(
              description: San(null).fullName,
              count: state.trainees
                  .where((element) => element.hasBadge('San'))
                  .length
                  .toString(),
            ),
            StatisticsItem(
              description: RSiWRD(null).fullName,
              count: state.trainees
                  .where((element) => element.hasBadge('RSiWRD'))
                  .length
                  .toString(),
            )
          ],
        );
      },
    );
  }
}

class StatisticsItem extends StatelessWidget {
  final String description;
  final String count;
  const StatisticsItem({required this.description, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(description),
        const SizedBox(
          width: 10,
        ),
        Text(count),
      ],
    );
  }
}
