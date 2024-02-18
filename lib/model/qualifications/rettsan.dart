import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/abstract_qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class RettSan extends AbstractQualification {
  RettSan(super.date);

  @override
  String get fullName => 'Rettungssanitäter';

  @override
  String get name => rettsan;

  @override
  String get shortName => 'RettSan';

  @override
  Icon get icon => const Icon(Icons.healing, color: Colors.yellow);

  @override
  String? get iconName => 'assets/images/san.svg';
}
