import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class Assistent extends Qualification {
  Assistent(super.date);

  @override
  String get fullName => 'Ausbildungsassistent';

  @override
  String get name => ausbildungsAssistent;

  @override
  String get shortName => 'Assistent';

  @override
  Icon get icon => const Icon(Icons.school_outlined);

  @override
  String? get iconName => null;
}
