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
  final DateTime? newDate = shouldSetCurrentDate ? DateTime.now() : null;

  // Start from the current qualifications to preserve non-checkbox entries
  // and existing dates.
  List<Qualification> qualifications = [...currentQualifications];

  void manage(
    String name,
    Qualification Function(DateTime?) create,
    bool shouldAdd,
  ) {
    final int idx = qualifications.indexWhere((e) => e.name == name);
    final DateTime? existingDate = idx >= 0 ? qualifications[idx].date : null;
    qualifications.removeWhere((e) => e.name == name);
    if (shouldAdd) {
      // Use new date if requested, otherwise preserve the existing date.
      qualifications.add(create(shouldSetCurrentDate ? newDate : existingDate));
    }
  }

  manage(pirat, Pirat.new, shouldAddPirat);
  manage(bronze, Bronze.new, shouldAddBronze);
  manage(silber, Silber.new, shouldAddSilber);
  manage(gold, Gold.new, shouldAddGold);
  manage(rettungsschwimmerBronze, RsBronze.new, shouldAddRsBronze);

  return qualifications;
}
