import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';
import 'package:training_organizer/model/qualifications/rs_bronze.dart';
import 'package:training_organizer/model/qualifications/silber.dart';

class AddQualificationUseCase {
  List<Qualification> execute({
    required List<Qualification> currentQualifications,
    required bool shouldSetCurrentDate,
    required bool shouldAddPirat,
    required bool shouldAddBronze,
    required bool shouldAddSilber,
    required bool shouldAddGold,
    required bool shouldAddRsBronze,
  }) {
    final DateTime? newDate = shouldSetCurrentDate ? DateTime.now() : null;

    List<Qualification> qualifications = [...currentQualifications];

    _updateQualification(
        qualifications, pirat, Pirat.new, shouldAddPirat, newDate);
    _updateQualification(
        qualifications, bronze, Bronze.new, shouldAddBronze, newDate);
    _updateQualification(
        qualifications, silber, Silber.new, shouldAddSilber, newDate);
    _updateQualification(
        qualifications, gold, Gold.new, shouldAddGold, newDate);
    _updateQualification(qualifications, rettungsschwimmerBronze, RsBronze.new,
        shouldAddRsBronze, newDate);

    return qualifications;
  }

  void _updateQualification(
    List<Qualification> currentQualifications,
    String qualificationName,
    Qualification Function(DateTime?) create,
    bool shouldAdd,
    DateTime? newDate,
  ) {
    final int index = currentQualifications
        .indexWhere((qualification) => qualification.name == qualificationName);
    final DateTime? existingDate =
        index >= 0 ? currentQualifications[index].date : null;
    currentQualifications.removeWhere(
        (qualification) => qualification.name == qualificationName);
    if (shouldAdd) {
      currentQualifications.add(create(newDate ?? existingDate));
    }
  }
}
