import 'package:flutter/foundation.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

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
      if (element.name == qualificationName && element.isUp2Date) {
        return true;
      }
    }
    return false;
  }

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
}
