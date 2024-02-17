import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/abstract_qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class AusbilderS2 extends AbstractQualification {
  AusbilderS2(super.date);

  @override
  String get fullName => 'Ausbilder S Stufe 2';

  @override
  String get name => ausbilderS2;

  @override
  String get shortName => 'AusbilderS2';

  @override
  Icon get icon => const Icon(Icons.school, color: Colors.blue);

  @override
  String? get iconName => null;
}
