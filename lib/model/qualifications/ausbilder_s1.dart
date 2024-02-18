import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class AusbilderS1 extends Qualification {
  AusbilderS1(super.date);

  @override
  String get fullName => 'Ausbilder S Stufe 1';

  @override
  String get name => ausbilderS1;

  @override
  String get shortName => 'AusbilderS1';

  @override
  Icon get icon => const Icon(Icons.school_outlined, color: Colors.blue);

  @override
  String? get iconName => null;
}
