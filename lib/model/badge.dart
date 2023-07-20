import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum BadgeType {
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
  ausbildungsassistent,
  ausbilderS1,
  ausbilderS2,
  ausbilderR1,
  ausbilderR2,
  gruppenleiter,
}

extension BadgeTypeShortName on BadgeType {
  String get shortName {
    switch (this) {
      case BadgeType.pirate:
        return 'Seeräuber';
      case BadgeType.bronze:
        return 'Bronze';
      case BadgeType.silber:
        return 'Silber';
      case BadgeType.gold:
        return 'Gold';
      case BadgeType.rettungschwimmerBronze:
        return 'RS Bronze';
      case BadgeType.rettungsschwimmerSilber:
        return 'RS Silber (< 2 Jahre)';
      case BadgeType.rettungsschwimmerGold:
        return 'RS Gold';
      case BadgeType.rettungsschwimmerImWasserrettungsdienst:
        return 'RSiWRD';
      case BadgeType.san:
        return 'San';
      case BadgeType.wassserretter:
        return 'Wasserretter';
      case BadgeType.ausbildungsassistent:
        return 'Assistent';
      case BadgeType.ausbilderS1:
        return 'AusbilderS1';
      case BadgeType.ausbilderS2:
        return 'AusbilderS2';
      case BadgeType.ausbilderR1:
        return 'AusbilderR1';
      case BadgeType.ausbilderR2:
        return 'AusbilderR2';
      case BadgeType.gruppenleiter:
        return 'Gruppenleiter';
    }
  }
}

extension BadgeTypeFullName on BadgeType {
  String get fullName {
    switch (this) {
      case BadgeType.pirate:
        return 'Seeräuber';
      case BadgeType.bronze:
        return 'Schwimmabzeichen Bronze';
      case BadgeType.silber:
        return 'Schwimmabzeichen Silber';
      case BadgeType.gold:
        return 'Schwimmabzeichen Gold';
      case BadgeType.rettungschwimmerBronze:
        return 'Rettungsschwimmabzeichen Bronze';
      case BadgeType.rettungsschwimmerSilber:
        return 'Rettungsschwimmabzeichen Silber';
      case BadgeType.rettungsschwimmerGold:
        return 'Rettungsschwimmabzeichen Gold';
      case BadgeType.rettungsschwimmerImWasserrettungsdienst:
        return 'Rettungsschwimmer im Wasserrettungsdient';
      case BadgeType.san:
        return 'Sanitätsdiensthelfer';
      case BadgeType.wassserretter:
        return 'Wasserretter';
      case BadgeType.ausbildungsassistent:
        return 'Ausbildungsassistent';
      case BadgeType.ausbilderS1:
        return 'Ausbilder S Stufe 1';
      case BadgeType.ausbilderS2:
        return 'Ausbilder S Stufe 2';
      case BadgeType.ausbilderR1:
        return 'Ausbilder R Stufe 1';
      case BadgeType.ausbilderR2:
        return 'Ausbilder R Stufe 2';
      case BadgeType.gruppenleiter:
        return 'Gruppenleiter';
    }
  }
}

extension BadgeTypeName on BadgeType {
  String get name {
    switch (this) {
      case BadgeType.pirate:
        return 'Seeräuber';
      case BadgeType.bronze:
        return 'Bronze';
      case BadgeType.silber:
        return 'Silber';
      case BadgeType.gold:
        return 'Gold';
      case BadgeType.rettungschwimmerBronze:
        return 'RettungsschwimmerBronze';
      case BadgeType.rettungsschwimmerSilber:
        return 'RettungsschwimmerSilber';
      case BadgeType.rettungsschwimmerGold:
        return 'RettungsschwimmerGold';
      case BadgeType.rettungsschwimmerImWasserrettungsdienst:
        return 'RSiWRD';
      case BadgeType.san:
        return 'San';
      case BadgeType.wassserretter:
        return 'Wasserretter';
      case BadgeType.ausbildungsassistent:
        return 'Ausbildungsassistent';
      case BadgeType.ausbilderS1:
        return 'AusbilderS1';
      case BadgeType.ausbilderS2:
        return 'AusbilderS2';
      case BadgeType.ausbilderR1:
        return 'AusbilderR1';
      case BadgeType.ausbilderR2:
        return 'AusbilderR2';
      case BadgeType.gruppenleiter:
        return 'Gruppenleiter';
    }
  }
}

extension BadgeTypeIcon on BadgeType {
  Icon get icon {
    switch (this) {
      case BadgeType.pirate:
        return const Icon(Icons.android);
      case BadgeType.bronze:
        return const Icon(Icons.check_circle, color: Colors.red);
      case BadgeType.silber:
        return const Icon(Icons.check_circle, color: Colors.grey);
      case BadgeType.gold:
        return const Icon(Icons.check_circle, color: Colors.yellow);
      case BadgeType.rettungschwimmerBronze:
        return const Icon(Icons.catching_pokemon, color: Colors.red);
      case BadgeType.rettungsschwimmerSilber:
        return const Icon(Icons.catching_pokemon, color: Colors.grey);
      case BadgeType.rettungsschwimmerGold:
        return const Icon(Icons.catching_pokemon, color: Colors.yellow);
      case BadgeType.rettungsschwimmerImWasserrettungsdienst:
        return const Icon(Icons.catching_pokemon, color: Colors.deepPurple);
      case BadgeType.wassserretter:
        return const Icon(Icons.healing, color: Colors.grey);
      case BadgeType.san:
        return const Icon(Icons.healing, color: Colors.red);
      case BadgeType.ausbildungsassistent:
        return const Icon(Icons.cruelty_free, color: Colors.yellow);
      case BadgeType.ausbilderS1:
        return const Icon(Icons.hdr_auto_outlined, color: Colors.red);
      case BadgeType.ausbilderS2:
        return const Icon(Icons.hdr_auto_outlined, color: Colors.grey);
      case BadgeType.ausbilderR1:
        return const Icon(Icons.hdr_auto, color: Colors.red);
      case BadgeType.ausbilderR2:
        return const Icon(Icons.hdr_auto, color: Colors.grey);
      case BadgeType.gruppenleiter:
        return const Icon(Icons.groups, color: Colors.grey);
    }
  }
}

class Qualification {
  final DateTime? date;
  final BadgeType badgeType;

  Qualification({
    this.date,
    required this.badgeType,
  });

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
        'name': badgeType.name,
        'date': date == null ? null : parseDateTimeToString(date!),
      };
}

abstract class BaseBadge {
  DateTime? date;
  bool hasBadge = false;

  BaseBadge(this.date);

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
  Qualification? getBadge(Map<String, dynamic> json) {
    DateTime? parsedDate = parseDateFromJson(json);
    BadgeType? badgeType = getBadgeType(json);

    if (badgeType != null) {
      return Qualification(date: parsedDate, badgeType: badgeType);
    }
    return null;
  }

  BadgeType? getBadgeType(Map<String, dynamic> json) {
    switch (json['name']) {
      case 'Pirate':
        return BadgeType.pirate;
      case 'Bronze':
        return BadgeType.bronze;
      case 'Silber':
        return BadgeType.silber;
      case 'Gold':
        return BadgeType.gold;
      case 'RettungsschwimmerBronze':
        return BadgeType.rettungschwimmerBronze;
      case 'RettungsschwimmerSilber':
        return BadgeType.rettungsschwimmerSilber;
      case 'RettungsschwimmerGold':
        return BadgeType.rettungsschwimmerGold;
      case 'Wasserretter':
        return BadgeType.wassserretter;
      case 'San':
        return BadgeType.san;
      case 'RSiWRD':
        return BadgeType.rettungsschwimmerImWasserrettungsdienst;
      case 'Ausbildungsassistent':
        return BadgeType.ausbildungsassistent;
      case 'AusbilderS1':
        return BadgeType.ausbilderS1;
      case 'AusbilderS2':
        return BadgeType.ausbilderS2;
      case 'AusbilderR1':
        return BadgeType.ausbilderR1;
      case 'AusbilderR2':
        return BadgeType.ausbilderR2;
      case 'Gruppenleiter':
        return BadgeType.gruppenleiter;
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
