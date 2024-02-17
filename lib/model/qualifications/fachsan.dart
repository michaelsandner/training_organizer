import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/abstract_qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class FachSan extends AbstractQualification {
  FachSan(super.date);

  @override
  String get fullName => 'Fachsanitäter';

  @override
  String get name => fachsan;

  @override
  String get shortName => 'FachSan';

  @override
  Icon get icon => const Icon(Icons.healing, color: Colors.grey);

  @override
  String? get iconName => 'assets/images/san.svg';
}
