import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/qualifications/assitent.dart';
import 'package:training_organizer/model/qualifications/ausbilder_r1.dart';
import 'package:training_organizer/model/qualifications/ausbilder_r2.dart';
import 'package:training_organizer/model/qualifications/ausbilder_s1.dart';
import 'package:training_organizer/model/qualifications/ausbilder_s2.dart';
import 'package:training_organizer/model/qualifications/gruppenleiter.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';
import 'package:training_organizer/statistic/ui/statistics_view.dart';

List<Qualification> _dataAusbilder = [
  Gruppenleiter(null),
  Assistent(null),
  AusbilderS1(null),
  AusbilderS2(null),
  AusbilderR1(null),
  AusbilderR2(null),
];

class Ausbilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Column(
          children: [
            const SubHeader(text: 'Ausbilder'),
            SfCartesianChart(
              primaryXAxis: const CategoryAxis(
                labelStyle: TextStyle(fontSize: 15),
              ),
              primaryYAxis:
                  const NumericAxis(minimum: 0, maximum: 5, interval: 1),
              series: <CartesianSeries>[
                ColumnSeries<Qualification, String>(
                  dataSource: _dataAusbilder,
                  xValueMapper: (Qualification qualification, _) =>
                      qualification.fullName,
                  yValueMapper: (Qualification qualification, _) =>
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
