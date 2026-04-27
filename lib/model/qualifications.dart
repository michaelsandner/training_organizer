import 'package:flutter/foundation.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';
import 'package:training_organizer/model/qualifications/qualification_validity.dart';

/// The set of qualifications a trainee has.
class Qualifications {
  final List<Qualification> qualifications;

  const Qualifications({this.qualifications = const []});

  factory Qualifications.fromJson(List<dynamic>? json) {
    final qualificationFactory = QualificationFactory();
    return Qualifications(
      qualifications:
          json == null ? [] : qualificationFactory.createQualifications(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qualifications': qualifications.map((q) => q.toJson()).toList(),
    };
  }

  /// Qualifications for which the isAchievedIntern flag is respected in statistics.
  static const Set<String> _internCheckedInStatistics = {gold, silber, bronze};

  bool hasQualificationFromYear(String qualificationName, int year) {
    for (var element in qualifications) {
      if (element.name == qualificationName &&
          element.date != null &&
          element.date!.year == year &&
          (!_internCheckedInStatistics.contains(qualificationName) ||
              element.isAchievedIntern)) {
        return true;
      }
    }
    return false;
  }

  bool hasQualification(String qualificationName) {
    for (var element in qualifications) {
      if (element.name == qualificationName &&
          (element.isUp2Date == QualificationValidity.valid ||
              element.isUp2Date == QualificationValidity.expiring) &&
          (!_internCheckedInStatistics.contains(qualificationName) ||
              element.isAchievedIntern)) {
        return true;
      }
    }
    return false;
  }

  /// Returns true if the trainee has the specified qualification and does not have any higher qualification that is still valid.
  bool hasQualificationAndNoHigherQualification(String qualificationName) {
    final hasValidQualification = qualifications.any((element) =>
        element.name == qualificationName &&
        (element.isUp2Date == QualificationValidity.valid ||
            element.isUp2Date == QualificationValidity.expiring) &&
        (!_internCheckedInStatistics.contains(qualificationName) ||
            element.isAchievedIntern));

    if (qualificationName == ausbildungsAssistent &&
        _hasAusbilderQualification()) {
      return false;
    }

    if ((qualificationName == rsiwrd || qualificationName == san) &&
        _hasWasserretterQualification()) {
      return false;
    }

    if ((qualificationName == san || qualificationName == fachsan) &&
        _hasRettSanQualification()) {
      return false;
    }

    if ((qualificationName == rettungsschwimmerBronze) &&
        qualifications
            .any((element) => element.name == rettungsschwimmerSilber)) {
      return false;
    }
    return hasValidQualification;
  }

  bool _hasAusbilderQualification() {
    return qualifications.any((element) =>
        element.name == ausbilderS1 ||
        element.name == ausbilderS2 ||
        element.name == ausbilderR1 ||
        element.name == ausbilderR2);
  }

  bool _hasWasserretterQualification() {
    return qualifications.any((element) => element.name == wasserretter);
  }

  bool _hasRettSanQualification() {
    return qualifications.any((element) => element.name == rettsan);
  }

  /// Returns a list of only the highest qualifications. For example, if a trainee has both RettSan and San, only RettSan will be returned for the icons, since it is the higher qualification.
  List<Qualification> getOnlyHighestQualifications() {
    List<Qualification> filteredQualifications =
        List<Qualification>.from(qualifications);
    if (qualifications
        .any((element) => element.name == rettungsschwimmerSilber)) {
      filteredQualifications
          .removeWhere((element) => element.name == rettungsschwimmerBronze);
    }

    if (_hasAusbilderQualification()) {
      filteredQualifications
          .removeWhere((element) => element.name == ausbildungsAssistent);
    }

    if (_hasWasserretterQualification()) {
      filteredQualifications.removeWhere(
          (element) => element.name == rsiwrd || element.name == san);
    }
    return filteredQualifications;
  }

  /// Returns the highest qualification as a single character:
  /// 'G' for Gold, 'S' for Silber, 'B' for Bronze, 'P' for Pirat, or '' if no qualifications are present.
  String getHighestQualification() {
    if (qualifications.isEmpty) {
      return '';
    }
    if (qualifications.any((element) => element.name == gold)) {
      return 'G';
    }
    if (qualifications.any((element) => element.name == silber)) {
      return 'S';
    }
    if (qualifications.any((element) => element.name == bronze)) {
      return 'B';
    }
    if (qualifications.any((element) => element.name == pirat)) {
      return 'P';
    }
    return '';
  }

  @override
  bool operator ==(Object other) =>
      other is Qualifications &&
      listEquals(other.qualifications, qualifications);

  @override
  int get hashCode => Object.hashAll(qualifications);
}
