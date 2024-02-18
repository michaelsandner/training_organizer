import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class RsGold extends Qualification {
  RsGold(super.date);

  @override
  String get fullName => 'Rettungsschwimmabzeichen Gold';

  @override
  String get name => rettungsschwimmerGold;

  @override
  String get shortName => 'RS Gold';

  @override
  Icon get icon => const Icon(Icons.catching_pokemon, color: Colors.yellow);

  @override
  String? get iconName => 'assets/images/DRSA_Gold.svg';
}
