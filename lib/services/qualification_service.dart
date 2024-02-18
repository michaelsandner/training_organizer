import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';
import 'package:training_organizer/model/qualifications/rs_bronze.dart';
import 'package:training_organizer/model/qualifications/silber.dart';

List<Qualification> addQualifications({
  required List<Qualification> currentQualifications,
  required bool shouldSetCurrentDate,
  required bool shouldAddPirat,
  required bool shouldAddBronze,
  required bool shouldAddSilber,
  required bool shouldAddGold,
  required bool shouldAddRsBronze,
}) {
  DateTime? date;
  List<Qualification> qualifications = [];

  if (shouldSetCurrentDate) {
    date = DateTime.now();
  }

  if (shouldAddPirat) {
    qualifications.removeWhere((element) => element.name == pirat);
    qualifications.add(Pirat(date));
  }
  if (shouldAddBronze) {
    qualifications.removeWhere((element) => element.name == bronze);
    qualifications.add(Bronze(date));
  }
  if (shouldAddSilber) {
    qualifications.removeWhere((element) => element.name == silber);
    qualifications.add(Silber(date));
  }
  if (shouldAddGold) {
    qualifications.removeWhere((element) => element.name == gold);
    qualifications.add(Gold(date));
  }
  if (shouldAddRsBronze) {
    qualifications
        .removeWhere((element) => element.name == rettungsschwimmerBronze);
    qualifications.add(RsBronze(date));
  }
  return qualifications;
}
