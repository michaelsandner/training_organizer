import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class FachSan extends Qualification {
  FachSan(super.date);

  @override
  String get fullName => 'Fachsanitäter*in';

  @override
  String get name => fachsan;

  @override
  String get shortName => 'FachSan';

  @override
  Icon get icon => const Icon(Icons.healing, color: Colors.grey);

  @override
  String? get iconName => 'assets/images/san.svg';
}
