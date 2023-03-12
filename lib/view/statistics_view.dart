import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/badge.dart' as badge;

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  int getCount(AppState state, String badge) {
    return state.trainees.where((element) => element.hasBadge(badge)).length;
  }

  @override
  Widget build(BuildContext context) {
    List<badge.Badge> dataAusbildung = [
      badge.RettungsschwimmerBronzeBadge(null),
      badge.RettungsschwimmerSilverBadge(null),
      badge.RSiWRD(null),
      badge.San(null),
      badge.Wasserretter(null),
    ];

    List<badge.Badge> dataAusbilder = [
      badge.Gruppenleiter(null),
      badge.AusbildungsAssistent(null),
      badge.AusbilderR1(null),
      badge.AusbilderR2(null),
      badge.AusbilderS1(null),
      badge.AusbilderS2(null),
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
                  labelStyle: const TextStyle(fontSize: 15),
                ),
                primaryYAxis: NumericAxis(minimum: 0, maximum: 20, interval: 5),
                series: <ChartSeries<badge.Badge, String>>[
                  ColumnSeries<badge.Badge, String>(
                      dataSource: dataAusbildung,
                      xValueMapper: (badge.Badge badge, _) => badge.shortName,
                      yValueMapper: (badge.Badge badge, _) =>
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
                series: <ChartSeries<badge.Badge, String>>[
                  ColumnSeries<badge.Badge, String>(
                    dataSource: dataAusbilder,
                    xValueMapper: (badge.Badge badge, _) => badge.fullName,
                    yValueMapper: (badge.Badge badge, _) =>
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
