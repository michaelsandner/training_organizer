import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class Gruppenleiter extends Qualification {
  Gruppenleiter(super.date);

  @override
  String get fullName => 'Gruppenleiter';

  @override
  String get name => gruppenleiter;

  @override
  String get shortName => 'Gruppenleiter';

  @override
  Icon get icon => const Icon(Icons.groups, color: Colors.grey);

  @override
  String? get iconName => null;
}
