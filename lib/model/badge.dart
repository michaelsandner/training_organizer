import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class Badge {
  DateTime? date;
  bool hasBadge = false;

  Badge(this.date);

  String get name;
  String get fullName;
  String get shortName;
  Icon get icon;

  void setBadge(DateTime date) {
    this.date = date;
    hasBadge = true;
  }

  bool get isUpToDate {
    if (date == null) {
      return false;
    }
    final dateDifference = DateTime.now().difference(date!);
    if (dateDifference > const Duration(days: 365 * 2)) {
      return false;
    }

    return true;
  }

  static String parseDateTimeToString(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date == null ? null : parseDateTimeToString(date!),
      };
}

class BadgeFactory {
  Badge? getBadge(Map<String, dynamic> json) {
    DateTime? parsedData = parseDateFromJson(json);
    switch (json['name']) {
      case 'Pirate':
        return PirateBadge(parsedData);
      case 'Bronze':
        return BronzeBadge(parsedData);
      case 'Silber':
        return SilverBadge(parsedData);
      case 'Gold':
        return GoldBadge(parsedData);
      case 'RettungsschwimmerBronze':
        return RettungsschwimmerBronzeBadge(parsedData);
      case 'RettungsschwimmerSilber':
        return RettungsschwimmerSilverBadge(parsedData);
      case 'RettungsschwimmerGold':
        return RettungsschwimmerBronzeBadge(parsedData);
      case 'Wasserretter':
        return Wasserretter(parsedData);
      case 'San':
        return San(parsedData);
      case 'RSiWRD':
        return RSiWRD(parsedData);
      case 'Ausbildungsassistent':
        return AusbildungsAssistent(parsedData);
      case 'AusbilderS1':
        return AusbilderS1(parsedData);
      case 'AusbilderS2':
        return AusbilderS2(parsedData);
      case 'AusbilderR1':
        return AusbilderR1(parsedData);
      case 'AusbilderR2':
        return AusbilderR2(parsedData);
      case 'Gruppenleiter':
        return Gruppenleiter(parsedData);
      default:
        return null;
    }
  }

  static DateTime? parseDateFromJson(dynamic json) {
    if (json['date'] == null) {
      return null;
    }
    try {
      final parsedDate = DateFormat('dd.MM.yyyy').parse(json['date']);
      return parsedDate;
    } catch (e) {
      return null;
    }
  }
}

class PirateBadge extends Badge {
  PirateBadge(DateTime? date) : super(date);

  @override
  String get name => 'Seeräuber';

  @override
  String get fullName => 'Seeräuber';

  @override
  String get shortName => 'Seeräuber';

  @override
  get icon => const Icon(Icons.android);
}

class BronzeBadge extends Badge {
  BronzeBadge(DateTime? date) : super(date);

  @override
  String get name => 'Bronze';

  @override
  String get fullName => 'Schwimmabzeichen Bronze';

  @override
  String get shortName => 'Bronze';

  @override
  get icon => const Icon(Icons.check_circle, color: Colors.red);
}

class SilverBadge extends Badge {
  SilverBadge(DateTime? date) : super(date);

  @override
  String get name => 'Silber';

  @override
  String get fullName => 'Schwimmabzeichen Silber';

  @override
  String get shortName => 'Silber';

  @override
  get icon => const Icon(Icons.check_circle, color: Colors.grey);
}

class GoldBadge extends Badge {
  GoldBadge(DateTime? date) : super(date);

  @override
  String get name => 'Gold';

  @override
  String get fullName => 'Schwimmabzeichen Gold';

  @override
  String get shortName => 'Gold';

  @override
  get icon => const Icon(Icons.check_circle, color: Colors.yellow);
}

class RettungsschwimmerBronzeBadge extends Badge {
  RettungsschwimmerBronzeBadge(DateTime? date) : super(date);

  @override
  String get name => 'RettungsschwimmerBronze';

  @override
  String get fullName => 'Rettungsschwimmabzeichen Bronze';

  @override
  String get shortName => 'RS Bronze';

  @override
  get icon => const Icon(Icons.catching_pokemon, color: Colors.red);
}

class RettungsschwimmerSilverBadge extends Badge {
  RettungsschwimmerSilverBadge(DateTime? date) : super(date);

  @override
  String get name => 'RettungsschwimmerSilber';

  @override
  String get fullName => 'Rettungsschwimmabzeichen Silber';

  @override
  String get shortName => 'RS Silber (< 2 Jahre)';

  @override
  get icon => const Icon(Icons.catching_pokemon, color: Colors.grey);
}

class RettungsschwimmerGoldBadge extends Badge {
  RettungsschwimmerGoldBadge(DateTime? date) : super(date);

  @override
  String get name => 'RettungsschwimmerGold';

  @override
  String get fullName => 'Rettungsschwimmabzeichen Gold';

  @override
  String get shortName => 'RS Gold';

  @override
  get icon => const Icon(Icons.catching_pokemon, color: Colors.grey);
}

class RSiWRD extends Badge {
  RSiWRD(DateTime? date) : super(date);

  @override
  String get name => 'RSiWRD';

  @override
  String get fullName => 'Rettungsschwimmer im Wasserrettungsdient';

  @override
  String get shortName => 'RSiWRD';

  @override
  get icon => const Icon(Icons.catching_pokemon, color: Colors.deepPurple);
}

class San extends Badge {
  San(DateTime? date) : super(date);

  @override
  String get name => 'San';

  @override
  String get fullName => 'Sanitätsdiensthelfer';

  @override
  String get shortName => 'San';

  @override
  get icon => const Icon(Icons.healing, color: Colors.red);
}

class Wasserretter extends Badge {
  Wasserretter(DateTime? date) : super(date);

  @override
  String get name => 'Wasserretter';

  @override
  String get fullName => 'Wasserretter';

  @override
  String get shortName => 'Wasserretter';

  @override
  get icon => const Icon(Icons.healing, color: Colors.grey);
}

class AusbildungsAssistent extends Badge {
  AusbildungsAssistent(DateTime? date) : super(date);

  @override
  String get name => 'Ausbildungsassistent';

  @override
  String get fullName => 'Ausbildungsassistent';

  @override
  String get shortName => 'Assistent';

  @override
  get icon => const Icon(Icons.cruelty_free, color: Colors.yellow);
}

class AusbilderR1 extends Badge {
  AusbilderR1(DateTime? date) : super(date);

  @override
  String get name => 'AusbilderR1';

  @override
  String get fullName => 'Ausbilder R Stufe 1';

  @override
  String get shortName => 'Ausbilder R1';

  @override
  get icon => const Icon(Icons.hdr_auto, color: Colors.red);
}

class AusbilderR2 extends Badge {
  AusbilderR2(DateTime? date) : super(date);

  @override
  String get name => 'AusbilderR2';

  @override
  String get fullName => 'Ausbilder R Stufe 2';

  @override
  String get shortName => 'Ausbilder R2';

  @override
  get icon => const Icon(Icons.hdr_auto, color: Colors.grey);
}

class AusbilderS1 extends Badge {
  AusbilderS1(DateTime? date) : super(date);

  @override
  String get name => 'AusbilderS1';

  @override
  String get fullName => 'Ausbilder S Stufe 1';

  @override
  String get shortName => 'Ausbilder S1';

  @override
  get icon => const Icon(Icons.hdr_auto_outlined, color: Colors.red);
}

class AusbilderS2 extends Badge {
  AusbilderS2(DateTime? date) : super(date);

  @override
  String get name => 'AusbilderS2';

  @override
  String get fullName => 'Ausbilder S Stufe 2';

  @override
  String get shortName => 'Ausbilder S2';

  @override
  get icon => const Icon(Icons.hdr_auto_outlined, color: Colors.grey);
}

class Gruppenleiter extends Badge {
  Gruppenleiter(DateTime? date) : super(date);

  @override
  String get name => 'Gruppenleiter';

  @override
  String get fullName => 'Gruppenleiter';

  @override
  String get shortName => 'Gruppenleiter';

  @override
  get icon => const Icon(Icons.groups, color: Colors.grey);
}
