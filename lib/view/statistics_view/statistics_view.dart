import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/qualifications/abstract_qualification.dart';
import 'package:training_organizer/model/qualifications/assitent.dart';
import 'package:training_organizer/model/qualifications/ausbilder_r1.dart';
import 'package:training_organizer/model/qualifications/ausbilder_r2.dart';
import 'package:training_organizer/model/qualifications/ausbilder_s1.dart';
import 'package:training_organizer/model/qualifications/ausbilder_s2.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/fachsan.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/gruppenleiter.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/rettsan.dart';
import 'package:training_organizer/model/qualifications/rs_bronze.dart';
import 'package:training_organizer/model/qualifications/rs_silber.dart';
import 'package:training_organizer/model/qualifications/rsiwrd.dart';
import 'package:training_organizer/model/qualifications/san.dart';
import 'package:training_organizer/model/qualifications/silber.dart';
import 'package:training_organizer/model/qualifications/wasserretter.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';

List<AbstractQualification> _dataJugendausbildung = [
  Pirat(null),
  Bronze(null),
  Silber(null),
  Gold(null),
];

List<AbstractQualification> _dataAusbildung = [
  RsBronze(null),
  RsSilber(null),
  RSiWRD(null),
  San(null),
  FachSan(null),
  Wasserretter(null),
  RettSan(null),
];

List<AbstractQualification> _dataAusbilder = [
  Gruppenleiter(null),
  Assistent(null),
  AusbilderS1(null),
  AusbilderS2(null),
  AusbilderR1(null),
  AusbilderR2(null),
];

int getqualificationOfYear(AppState state, String qualification, int year) {
  return state.trainees
      .where((element) => element.hasQualificationFromYear(qualification, year))
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
              series: <ChartSeries<AbstractQualification, String>>[
                ColumnSeries<AbstractQualification, String>(
                    dataSource: _dataJugendausbildung,
                    xValueMapper: (AbstractQualification qualification, _) =>
                        qualification.shortName,
                    yValueMapper: (AbstractQualification qualification, _) =>
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
              series: <ChartSeries<AbstractQualification, String>>[
                ColumnSeries<AbstractQualification, String>(
                    dataSource: _dataAusbildung,
                    xValueMapper: (AbstractQualification qualification, _) =>
                        qualification.shortName,
                    yValueMapper: (AbstractQualification qualification, _) =>
                        TraineesFilterService
                            .getCountOfTraineesWithQualification(
                                state.trainees, qualification.name),
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
              series: <ChartSeries<AbstractQualification, String>>[
                ColumnSeries<AbstractQualification, String>(
                  dataSource: _dataAusbilder,
                  xValueMapper: (AbstractQualification qualification, _) =>
                      qualification.fullName,
                  yValueMapper: (AbstractQualification qualification, _) =>
                      TraineesFilterService.getCountOfTraineesWithQualification(
                          state.trainees, qualification.name),
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
