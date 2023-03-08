import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/badge.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  int getCount(AppState state, String badge) {
    return state.trainees.where((element) => element.hasBadge(badge)).length;
  }

  @override
  Widget build(BuildContext context) {
    List<Badge> dataAusbildung = [
      RettungsschwimmerBronzeBadge(null),
      RettungsschwimmerSilverBadge(null),
      RSiWRD(null),
      San(null),
      Wasserretter(null),
    ];

    List<Badge> dataAusbilder = [
      AusbildungsAssistent(null),
      AusbilderR1(null),
      AusbilderR2(null),
      AusbilderS1(null),
      AusbilderS2(null),
    ];
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                'Ausbildungsstand',
                style: TextStyle(fontSize: 30),
              ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(fontSize: 10),
                ),
                primaryYAxis: NumericAxis(minimum: 0, maximum: 20, interval: 5),
                series: <ChartSeries<Badge, String>>[
                  ColumnSeries<Badge, String>(
                      dataSource: dataAusbildung,
                      xValueMapper: (Badge badge, _) => badge.fullName,
                      yValueMapper: (Badge badge, _) =>
                          getCount(state, badge.name),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      pointColorMapper: (_, __) => Colors.red),
                ],
              ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(fontSize: 15),
                ),
                primaryYAxis: NumericAxis(minimum: 0, maximum: 5, interval: 1),
                series: <ChartSeries<Badge, String>>[
                  ColumnSeries<Badge, String>(
                    dataSource: dataAusbilder,
                    xValueMapper: (Badge badge, _) => badge.fullName,
                    yValueMapper: (Badge badge, _) =>
                        getCount(state, badge.name),
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          ),
        );
        // return ListView(
        //   children: [
        //     StatisticsItem(
        //       description: Wasserretter(null).fullName,
        //       count: state.trainees
        //           .where((element) => element.hasBadge('Wasserretter'))
        //           .length
        //           .toString(),
        //     ),
        //     StatisticsItem(
        //       description: San(null).fullName,
        //       count: state.trainees
        //           .where((element) => element.hasBadge('San'))
        //           .length
        //           .toString(),
        //     ),
        //     StatisticsItem(
        //       description: RSiWRD(null).fullName,
        //       count: state.trainees
        //           .where((element) => element.hasBadge('RSiWRD'))
        //           .length
        //           .toString(),
        //     )
        //   ],
        // );
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
