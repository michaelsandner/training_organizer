import 'package:flutter/material.dart';

enum QualificationType {
  pirate,
  bronze,
  silber,
  gold,
  rettungschwimmerBronze,
  rettungsschwimmerSilber,
  rettungsschwimmerGold,
  rettungsschwimmerImWasserrettungsdienst,
  wassserretter,
  san,
  fachsan,
  rettsan,
  ausbildungsassistent,
  ausbilderS1,
  ausbilderS2,
  ausbilderR1,
  ausbilderR2,
  gruppenleiter,
}

extension QualificationTypeShortName on QualificationType {
  String get shortName {
    switch (this) {
      case QualificationType.pirate:
        return 'Seeräuber';
      case QualificationType.bronze:
        return 'Bronze';
      case QualificationType.silber:
        return 'Silber';
      case QualificationType.gold:
        return 'Gold';
      case QualificationType.rettungschwimmerBronze:
        return 'RS Bronze';
      case QualificationType.rettungsschwimmerSilber:
        return 'RS Silber (< 2 Jahre)';
      case QualificationType.rettungsschwimmerGold:
        return 'RS Gold';
      case QualificationType.rettungsschwimmerImWasserrettungsdienst:
        return 'RSiWRD';
      case QualificationType.san:
        return 'San';
      case QualificationType.fachsan:
        return 'FachSan';
      case QualificationType.rettsan:
        return 'RettSan';
      case QualificationType.wassserretter:
        return 'Wasserretter';
      case QualificationType.ausbildungsassistent:
        return 'Assistent';
      case QualificationType.ausbilderS1:
        return 'AusbilderS1';
      case QualificationType.ausbilderS2:
        return 'AusbilderS2';
      case QualificationType.ausbilderR1:
        return 'AusbilderR1';
      case QualificationType.ausbilderR2:
        return 'AusbilderR2';
      case QualificationType.gruppenleiter:
        return 'Gruppenleiter';
    }
  }
}

extension QualificationTypeFullName on QualificationType {
  String get fullName {
    switch (this) {
      case QualificationType.pirate:
        return 'Seeräuber';
      case QualificationType.bronze:
        return 'Schwimmabzeichen Bronze';
      case QualificationType.silber:
        return 'Schwimmabzeichen Silber';
      case QualificationType.gold:
        return 'Schwimmabzeichen Gold';
      case QualificationType.rettungschwimmerBronze:
        return 'Rettungsschwimmabzeichen Bronze';
      case QualificationType.rettungsschwimmerSilber:
        return 'Rettungsschwimmabzeichen Silber';
      case QualificationType.rettungsschwimmerGold:
        return 'Rettungsschwimmabzeichen Gold';
      case QualificationType.rettungsschwimmerImWasserrettungsdienst:
        return 'Rettungsschwimmer im Wasserrettungsdient';
      case QualificationType.san:
        return 'Sanitätsdiensthelfer';
      case QualificationType.fachsan:
        return 'Fachsanitäter';
      case QualificationType.rettsan:
        return 'Rettungssanitäter';
      case QualificationType.wassserretter:
        return 'Wasserretter';
      case QualificationType.ausbildungsassistent:
        return 'Ausbildungsassistent';
      case QualificationType.ausbilderS1:
        return 'Ausbilder S Stufe 1';
      case QualificationType.ausbilderS2:
        return 'Ausbilder S Stufe 2';
      case QualificationType.ausbilderR1:
        return 'Ausbilder R Stufe 1';
      case QualificationType.ausbilderR2:
        return 'Ausbilder R Stufe 2';
      case QualificationType.gruppenleiter:
        return 'Gruppenleiter';
    }
  }
}

extension QualificationTypeName on QualificationType {
  String get name {
    switch (this) {
      case QualificationType.pirate:
        return 'Pirat';
      case QualificationType.bronze:
        return 'Bronze';
      case QualificationType.silber:
        return 'Silber';
      case QualificationType.gold:
        return 'Gold';
      case QualificationType.rettungschwimmerBronze:
        return 'RettungsschwimmerBronze';
      case QualificationType.rettungsschwimmerSilber:
        return 'RettungsschwimmerSilber';
      case QualificationType.rettungsschwimmerGold:
        return 'RettungsschwimmerGold';
      case QualificationType.rettungsschwimmerImWasserrettungsdienst:
        return 'RSiWRD';
      case QualificationType.san:
        return 'San';
      case QualificationType.fachsan:
        return 'FachSan';
      case QualificationType.rettsan:
        return 'RettSan';
      case QualificationType.wassserretter:
        return 'Wasserretter';
      case QualificationType.ausbildungsassistent:
        return 'Ausbildungsassistent';
      case QualificationType.ausbilderS1:
        return 'AusbilderS1';
      case QualificationType.ausbilderS2:
        return 'AusbilderS2';
      case QualificationType.ausbilderR1:
        return 'AusbilderR1';
      case QualificationType.ausbilderR2:
        return 'AusbilderR2';
      case QualificationType.gruppenleiter:
        return 'Gruppenleiter';
    }
  }
}

extension QualificationTypeIcon on QualificationType {
  Icon get icon {
    switch (this) {
      case QualificationType.pirate:
        return const Icon(Icons.android);
      case QualificationType.bronze:
        return const Icon(Icons.check_circle, color: Colors.red);
      case QualificationType.silber:
        return const Icon(Icons.check_circle, color: Colors.grey);
      case QualificationType.gold:
        return const Icon(Icons.check_circle, color: Colors.yellow);
      case QualificationType.rettungschwimmerBronze:
        return const Icon(Icons.catching_pokemon, color: Colors.red);
      case QualificationType.rettungsschwimmerSilber:
        return const Icon(Icons.catching_pokemon, color: Colors.grey);
      case QualificationType.rettungsschwimmerGold:
        return const Icon(Icons.catching_pokemon, color: Colors.yellow);
      case QualificationType.rettungsschwimmerImWasserrettungsdienst:
        return const Icon(Icons.catching_pokemon, color: Colors.deepPurple);
      case QualificationType.wassserretter:
        return const Icon(Icons.healing, color: Colors.grey);
      case QualificationType.san:
        return const Icon(Icons.healing, color: Colors.red);
      case QualificationType.fachsan:
        return const Icon(Icons.healing, color: Colors.grey);
      case QualificationType.rettsan:
        return const Icon(Icons.healing, color: Colors.yellow);
      case QualificationType.ausbildungsassistent:
        return const Icon(Icons.cruelty_free, color: Colors.yellow);
      case QualificationType.ausbilderS1:
        return const Icon(Icons.hdr_auto_outlined, color: Colors.red);
      case QualificationType.ausbilderS2:
        return const Icon(Icons.hdr_auto_outlined, color: Colors.grey);
      case QualificationType.ausbilderR1:
        return const Icon(Icons.hdr_auto, color: Colors.red);
      case QualificationType.ausbilderR2:
        return const Icon(Icons.hdr_auto, color: Colors.grey);
      case QualificationType.gruppenleiter:
        return const Icon(Icons.groups, color: Colors.grey);
    }
  }
}
