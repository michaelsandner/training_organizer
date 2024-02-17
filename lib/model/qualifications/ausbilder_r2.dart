import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/abstract_qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class AusbilderR2 extends AbstractQualification {
  AusbilderR2(super.date);

  @override
  String get fullName => 'Ausbilder R Stufe 2';

  @override
  String get name => ausbilderR2;

  @override
  String get shortName => 'AusbilderR2';

  @override
  Icon get icon => const Icon(Icons.school, color: Colors.red);

  @override
  String? get iconName => null;
}
