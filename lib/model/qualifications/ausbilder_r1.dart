import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class AusbilderR1 extends Qualification {
  AusbilderR1(super.date);

  @override
  String get fullName => 'Ausbilder*in R Stufe 1';

  @override
  String get name => ausbilderR1;

  @override
  String get shortName => 'AusbilderR1';

  @override
  Icon get icon => const Icon(Icons.school_outlined, color: Colors.red);

  @override
  String? get iconName => null;
}
