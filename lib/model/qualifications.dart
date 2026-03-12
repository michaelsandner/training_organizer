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

  bool hasQualificationFromYear(String qualificationName, int year) {
    for (var element in qualifications) {
      if (element.name == qualificationName &&
          element.date != null &&
          element.date!.year == year) {
        return true;
      }
    }
    return false;
  }

  bool hasQualification(String qualificationName) {
    for (var element in qualifications) {
      if (element.name == qualificationName &&
          element.isUp2Date == QualificationValidity.valid) {
        return true;
      }
    }
    return false;
  }

  /// Returns true if the trainee has the specified qualification and does not have any higher qualification that is still valid.
  bool hasQualificationAndNoHigherQualification(String qualificationName) {
    final hasValidQualification = qualifications.any((element) =>
        element.name == qualificationName &&
        element.isUp2Date == QualificationValidity.valid);

    if (qualificationName == ausbildungsAssistent &&
        _hasAusbilderQualification()) {
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
