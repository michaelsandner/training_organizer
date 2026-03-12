import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/qualifications/fachsan.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/rettsan.dart';
import 'package:training_organizer/model/qualifications/rs_bronze.dart';
import 'package:training_organizer/model/qualifications/rs_silber.dart';
import 'package:training_organizer/model/qualifications/rsiwrd.dart';
import 'package:training_organizer/model/qualifications/san.dart';
import 'package:training_organizer/model/qualifications/wasserretter.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';
import 'package:training_organizer/statistic/ui/statistics_view.dart';

List<Qualification> _dataAusbildung = [
  RsBronze(null),
  RsSilber(null),
  RSiWRD(null),
  San(null),
  FachSan(null),
  Wasserretter(null),
  RettSan(null),
];

class AktivenAusbildungen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Column(
          children: [
            const SubHeader(text: 'Aktiven Ausbildungen'),
            SfCartesianChart(
              primaryXAxis: const CategoryAxis(
                labelStyle: TextStyle(fontSize: 15),
              ),
              primaryYAxis:
                  const NumericAxis(minimum: 0, maximum: 20, interval: 5),
              series: <CartesianSeries>[
                ColumnSeries<Qualification, String>(
                    dataSource: _dataAusbildung,
                    xValueMapper: (Qualification qualification, _) =>
                        qualification.shortName,
                    yValueMapper: (Qualification qualification, _) =>
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
