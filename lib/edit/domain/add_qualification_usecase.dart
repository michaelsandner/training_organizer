import 'package:training_organizer/model/qualifications.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';
import 'package:training_organizer/model/qualifications/rs_bronze.dart';
import 'package:training_organizer/model/qualifications/silber.dart';

class AddQualificationUseCase {
  Qualifications execute({
    required Qualifications currentQualifications,
    required bool shouldSetCurrentDate,
    required bool shouldAddPirat,
    required bool shouldAddBronze,
    required bool shouldAddSilber,
    required bool shouldAddGold,
    required bool shouldAddRsBronze,
  }) {
    final DateTime? newDate = shouldSetCurrentDate ? DateTime.now() : null;

    final List<Qualification> mutableList =
        List<Qualification>.from(currentQualifications.qualifications);

    _updateQualification(
        mutableList, pirat, Pirat.new, shouldAddPirat, newDate);
    _updateQualification(
        mutableList, bronze, Bronze.new, shouldAddBronze, newDate);
    _updateQualification(
        mutableList, silber, Silber.new, shouldAddSilber, newDate);
    _updateQualification(mutableList, gold, Gold.new, shouldAddGold, newDate);
    _updateQualification(mutableList, rettungsschwimmerBronze, RsBronze.new,
        shouldAddRsBronze, newDate);

    return Qualifications(qualifications: mutableList);
  }

  void _updateQualification(
    List<Qualification> qualifications,
    String qualificationName,
    Qualification Function(DateTime?) create,
    bool shouldAdd,
    DateTime? newDate,
  ) {
    final int index = qualifications
        .indexWhere((qualification) => qualification.name == qualificationName);
    final DateTime? existingDate =
        index >= 0 ? qualifications[index].date : null;
    qualifications.removeWhere(
        (qualification) => qualification.name == qualificationName);
    if (shouldAdd) {
      qualifications.add(create(newDate ?? existingDate));
    }
  }
}
