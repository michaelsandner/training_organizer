import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class RsBronze extends Qualification {
  RsBronze(super.date);

  @override
  String get fullName => 'Rettungsschwimmabzeichen Bronze';

  @override
  String get name => rettungsschwimmerBronze;

  @override
  String get shortName => 'RS Bronze';

  @override
  Icon get icon => const Icon(Icons.catching_pokemon, color: Colors.red);

  @override
  String? get iconName => 'assets/images/DRSA_Bronze.svg';
}
