import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class RsSilber extends Qualification {
  RsSilber(super.date);

  @override
  String get fullName => 'Rettungsschwimmabzeichen Silber';

  @override
  String get name => rettungsschwimmerSilber;

  @override
  String get shortName => 'RS Silber (< 2 Jahre)';

  @override
  Icon get icon => const Icon(Icons.catching_pokemon, color: Colors.grey);

  @override
  String? get iconName => 'assets/images/DRSA_Silber.svg';

  @override
  bool get isUp2Date {
    if (date == null) {
      return false;
    }
    final dateDifference = DateTime.now().difference(date!);
    if (dateDifference > const Duration(days: 365 * 2)) {
      return false;
    }

    return true;
  }
}
