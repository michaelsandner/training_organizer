import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:training_organizer/cubit/trainees_cubit.dart';
import 'package:training_organizer/cubit/trainees_state.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/silber.dart';
import 'package:training_organizer/statistic/ui/aktiven_statistics_view.dart';
import 'package:training_organizer/statistic/ui/ausbilder_statistics_view.dart';

List<Qualification> _dataJugendausbildung = [
  Pirat(null),
  Bronze(null),
  Silber(null),
  Gold(null),
];

int getqualificationOfYear(TraineesState state, String qualification, int year) {
  return state.trainees
      .where((element) =>
          element.qualifications.hasQualificationFromYear(qualification, year))
      .length;
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TraineesCubit, TraineesState>(
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
                AktivenAusbildungen(),
                Ausbilder(),
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
    return BlocBuilder<TraineesCubit, TraineesState>(
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
              primaryXAxis: const CategoryAxis(
                labelStyle: TextStyle(fontSize: 15),
              ),
              primaryYAxis:
                  const NumericAxis(minimum: 0, maximum: 20, interval: 5),
              series: <CartesianSeries>[
                ColumnSeries<Qualification, String>(
                    dataSource: _dataJugendausbildung,
                    xValueMapper: (Qualification qualification, _) =>
                        qualification.shortName,
                    yValueMapper: (Qualification qualification, _) =>
                        getqualificationOfYear(state, qualification.name, year),
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
