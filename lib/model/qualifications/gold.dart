import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class Gold extends Qualification {
  Gold(super.date);

  @override
  String get fullName => 'Schwimmabzeichen Gold';

  @override
  String get name => gold;

  @override
  String get shortName => 'Gold';

  @override
  Icon get icon => const Icon(Icons.check_circle, color: Colors.yellow);

  @override
  String? get iconName => 'assets/images/DSA_Gold.svg';
}
