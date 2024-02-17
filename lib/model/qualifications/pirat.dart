import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/abstract_qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class Pirat extends AbstractQualification {
  Pirat(super.date);

  @override
  String get fullName => 'Seeräuber';

  @override
  String get name => pirat;

  @override
  String get shortName => 'Seeräuber';

  @override
  Icon get icon => const Icon(Icons.android);

  @override
  String? get iconName => null;
}
