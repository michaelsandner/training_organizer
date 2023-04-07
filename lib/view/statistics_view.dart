import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/badge.dart' as badge;

List<badge.Badge> _dataJugendausbildung = [
  badge.BronzeBadge(null),
  badge.SilverBadge(null),
  badge.GoldBadge(null),
];
List<badge.Badge> _dataAusbildung = [
  badge.RettungsschwimmerBronzeBadge(null),
  badge.RettungsschwimmerSilverBadge(null),
  badge.RSiWRD(null),
  badge.San(null),
  badge.Wasserretter(null),
];

List<badge.Badge> _dataAusbilder = [
  badge.Gruppenleiter(null),
  badge.AusbildungsAssistent(null),
  badge.AusbilderR1(null),
  badge.AusbilderR2(null),
  badge.AusbilderS1(null),
  badge.AusbilderS2(null),
];

int getCount(AppState state, String badge) {
  return state.trainees.where((element) => element.hasBadge(badge)).length;
}

int getBadgeOfThisYear(AppState state, String badge) {
  return state.trainees
      .where((element) => element.hasBadgeFromYear(badge, DateTime.now().year))
      .length;
}

int getBadgeOfLastYear(AppState state, String badge, int year) {
  return state.trainees
      .where((element) => element.hasBadgeFromYear(badge, year))
      .length;
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Ausbildungsstand',
                  style: TextStyle(fontSize: 30),
                ),
                _Jugendschwimmausbildungen(),
                _AktivenAusbildungen(),
                _Ausbilder(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Jugendschwimmausbildungen extends StatefulWidget {
  @override
  State<_Jugendschwimmausbildungen> createState() =>
      _JugendschwimmausbildungenState();
}

List<String> _dropDownValues = ['Aktuelles Jahr', 'Letztes Jahr'];

class _JugendschwimmausbildungenState
    extends State<_Jugendschwimmausbildungen> {
  String? dropDownValue = _dropDownValues.first;
  int year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                const SubHeader(text: 'Jugendschwimmabzeichen'),
                const SizedBox(width: 30),
                DropdownButton<String>(
                  focusColor: Colors.white,
                  elevation: 15,
                  icon: const Icon(Icons.arrow_downward),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  value: dropDownValue,
                  items: _dropDownValues
                      .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                      .toList(),
                  onChanged: (String? value) => setState(() {
                    dropDownValue = value;
                    if (dropDownValue == 'Aktuelles Jahr') {
                      year = DateTime.now().year;
                    }
                    if (dropDownValue == 'Letztes Jahr') {
                      year = DateTime.now().year - 1;
                    }
                  }),
                )
              ],
            ),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: const TextStyle(fontSize: 15),
              ),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 20, interval: 5),
              series: <ChartSeries<badge.Badge, String>>[
                ColumnSeries<badge.Badge, String>(
                    dataSource: _dataJugendausbildung,
                    xValueMapper: (badge.Badge badge, _) => badge.shortName,
                    yValueMapper: (badge.Badge badge, _) =>
                        getBadgeOfLastYear(state, badge.name, year),
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    pointColorMapper: (_, __) => Colors.green),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _AktivenAusbildungen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Column(
          children: [
            const SubHeader(text: 'Aktiven Ausbildungen'),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: const TextStyle(fontSize: 15),
              ),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 20, interval: 5),
              series: <ChartSeries<badge.Badge, String>>[
                ColumnSeries<badge.Badge, String>(
                    dataSource: _dataAusbildung,
                    xValueMapper: (badge.Badge badge, _) => badge.shortName,
                    yValueMapper: (badge.Badge badge, _) =>
                        getCount(state, badge.name),
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    pointColorMapper: (_, __) => Colors.red),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Ausbilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Column(
          children: [
            const SubHeader(text: 'Ausbilder'),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: const TextStyle(fontSize: 15),
              ),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 5, interval: 1),
              series: <ChartSeries<badge.Badge, String>>[
                ColumnSeries<badge.Badge, String>(
                  dataSource: _dataAusbilder,
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
        );
      },
    );
  }
}

class SubHeader extends StatelessWidget {
  final String text;
  const SubHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 0, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 22),
        ),
      ),
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
