import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/abstract_qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class Bronze extends AbstractQualification {
  Bronze(super.date);

  @override
  String get fullName => 'Schwimmabzeichen Bronze';

  @override
  String get name => bronze;

  @override
  String get shortName => 'Bronze';

  @override
  Icon get icon => const Icon(Icons.check_circle, color: Colors.red);

  @override
  String? get iconName => 'assets/images/DSA_Bronze.svg';
}
