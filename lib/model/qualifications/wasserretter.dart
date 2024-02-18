import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class Wasserretter extends Qualification {
  Wasserretter(super.date);

  @override
  String get fullName => 'Wasserretter*in';

  @override
  String get name => wasserretter;

  @override
  String get shortName => 'Wasserretter';

  @override
  Icon get icon => const Icon(Icons.healing, color: Colors.grey);

  @override
  String? get iconName => 'assets/images/wasserretter.svg';
}
