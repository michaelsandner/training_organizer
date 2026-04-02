import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';
import 'package:training_organizer/model/qualifications/qualification_validity.dart';

class EhKurs extends Qualification {
  EhKurs(super.date);

  @override
  String get fullName => 'EH-Kurs';

  @override
  String get name => ehKurs;

  @override
  String get shortName => 'EH-Kurs (< 2 Jahre)';

  @override
  Icon get icon => const Icon(Icons.add_circle, color: Colors.red);

  @override
  String? get iconName => null;

  @override
  QualificationValidity get isUp2Date {
    if (date == null) {
      return QualificationValidity.expired;
    }
    final dateDifference = DateTime.now().difference(date!);
    if (dateDifference >= const Duration(days: (365 * 2))) {
      return QualificationValidity.expired;
    }
    if (dateDifference >= const Duration(days: (400))) {
      return QualificationValidity.expiring;
    }

    return QualificationValidity.valid;
  }
}
