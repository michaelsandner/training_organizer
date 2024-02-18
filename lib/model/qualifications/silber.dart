import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class Silber extends Qualification {
  Silber(super.date);

  @override
  String get fullName => 'Schwimmabzeichen Silber';

  @override
  String get name => silber;

  @override
  String get shortName => 'Silber';

  @override
  Icon get icon => const Icon(Icons.check_circle, color: Colors.grey);

  @override
  String? get iconName => 'assets/images/DSA_Silber.svg';
}
