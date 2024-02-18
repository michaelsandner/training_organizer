import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/abstract_qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class San extends AbstractQualification {
  San(super.date);

  @override
  String get fullName => 'Sanitätsdiensthelfer';

  @override
  String get name => san;

  @override
  String get shortName => 'San';

  @override
  Icon get icon => const Icon(Icons.healing, color: Colors.red);

  @override
  String? get iconName => 'assets/images/san.svg';
}
