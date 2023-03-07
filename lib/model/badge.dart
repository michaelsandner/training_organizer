import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class Badge {
  DateTime? date;
  bool hasBadge = false;

  Badge(this.date);

  String get name;
  String get fullName;
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

  static String parseDateTimeToString(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date == null ? null : parseDateTimeToString(date!),
      };
}

class BronzeBadge extends Badge {
  BronzeBadge(DateTime? date) : super(date);

  factory BronzeBadge.fromJson(dynamic json) {
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return BronzeBadge(null);
    }

    return BronzeBadge(parsedDate);
  }

  @override
  String get name => 'Bronze';

  @override
  String get fullName => 'Schwimmabzeichen Bronze';

  @override
  get icon => const Icon(Icons.check_circle, color: Colors.red);
}

class SilverBadge extends Badge {
  SilverBadge(DateTime? date) : super(date);

  factory SilverBadge.fromJson(dynamic json) {
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return SilverBadge(null);
    }

    return SilverBadge(parsedDate);
  }

  @override
  String get name => 'Silber';

  @override
  String get fullName => 'Schwimmabzeichen Silber';

  @override
  get icon => const Icon(Icons.check_circle, color: Colors.grey);
}

class GoldBadge extends Badge {
  GoldBadge(DateTime? date) : super(date);

  factory GoldBadge.fromJson(dynamic json) {
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return GoldBadge(null);
    }

    return GoldBadge(parsedDate);
  }

  @override
  String get name => 'Gold';

  @override
  String get fullName => 'Schwimmabzeichen Gold';

  @override
  get icon => const Icon(Icons.check_circle, color: Colors.yellow);
}

class RettungsschwimmerBronzeBadge extends Badge {
  RettungsschwimmerBronzeBadge(DateTime? date) : super(date);

  factory RettungsschwimmerBronzeBadge.fromJson(dynamic json) {
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return RettungsschwimmerBronzeBadge(null);
    }

    return RettungsschwimmerBronzeBadge(parsedDate);
  }

  @override
  String get name => 'RettungsschwimmerBronze';

  @override
  String get fullName => 'Rettungsschwimmabzeichen Bronze';

  @override
  get icon => const Icon(Icons.catching_pokemon, color: Colors.red);
}

class RettungsschwimmerSilverBadge extends Badge {
  RettungsschwimmerSilverBadge(DateTime? date) : super(date);

  factory RettungsschwimmerSilverBadge.fromJson(dynamic json) {
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return RettungsschwimmerSilverBadge(null);
    }

    return RettungsschwimmerSilverBadge(parsedDate);
  }

  @override
  String get name => 'RettungsschwimmerSilber';

  @override
  String get fullName => 'Rettungsschwimmabzeichen Silber';

  @override
  get icon => const Icon(Icons.catching_pokemon, color: Colors.grey);
}

class RettungsschwimmerGoldBadge extends Badge {
  RettungsschwimmerGoldBadge(DateTime? date) : super(date);

  factory RettungsschwimmerGoldBadge.fromJson(dynamic json) {
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return RettungsschwimmerGoldBadge(null);
    }
    return RettungsschwimmerGoldBadge(parsedDate);
  }

  @override
  String get name => 'RettungsschwimmerGold';

  @override
  String get fullName => 'Rettungsschwimmabzeichen Gold';

  @override
  get icon => const Icon(Icons.catching_pokemon, color: Colors.grey);
}

class RSiWRD extends Badge {
  RSiWRD(DateTime? date) : super(date);

  factory RSiWRD.fromJson(dynamic json) {
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return RSiWRD(null);
    }
    return RSiWRD(parsedDate);
  }

  @override
  String get name => 'RSiWRD';

  @override
  String get fullName => 'Rettungsschwimmer im Wasserrettungsdient';

  @override
  get icon => const Icon(Icons.cruelty_free, color: Colors.red);
}

class San extends Badge {
  San(DateTime? date) : super(date);

  factory San.fromJson(dynamic json) {
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return San(null);
    }
    return San(parsedDate);
  }

  @override
  String get name => 'San';

  @override
  String get fullName => 'Sanitätsdiensthelfer';

  @override
  get icon => const Icon(Icons.cruelty_free, color: Colors.grey);
}

class Wasserretter extends Badge {
  Wasserretter(DateTime? date) : super(date);

  factory Wasserretter.fromJson(dynamic json) {
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return Wasserretter(null);
    }
    return Wasserretter(parsedDate);
  }

  @override
  String get name => 'Wasserretter';

  @override
  String get fullName => 'Wasserretter';

  @override
  get icon => const Icon(Icons.cruelty_free, color: Colors.yellow);
}
