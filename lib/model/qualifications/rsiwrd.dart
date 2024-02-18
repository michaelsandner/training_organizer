import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

class RSiWRD extends Qualification {
  RSiWRD(super.date);

  @override
  String get fullName => 'Rettungsschwimmer im Wasserrettungsdient';

  @override
  String get name => rsiwrd;

  @override
  String get shortName => 'RSiWRD';

  @override
  Icon get icon => const Icon(Icons.catching_pokemon, color: Colors.deepPurple);

  @override
  String? get iconName => 'assets/images/rsiwrd.svg';
}
