import 'package:intl/intl.dart';

abstract class Badge {
  DateTime? date;
  bool hasBadge = false;

  String get name;

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
  BronzeBadge();

  factory BronzeBadge.fromJson(dynamic json) {
    final badge = BronzeBadge();
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return badge;
    }
    badge.setBadge(parsedDate);
    return badge;
  }

  @override
  String get name => 'Bronze';
}

class SilverBadge extends Badge {
  SilverBadge();

  factory SilverBadge.fromJson(dynamic json) {
    final badge = SilverBadge();
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return badge;
    }
    badge.setBadge(parsedDate);
    return badge;
  }

  @override
  String get name => 'Silber';
}

class GoldBadge extends Badge {
  GoldBadge();

  factory GoldBadge.fromJson(dynamic json) {
    final badge = GoldBadge();
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return badge;
    }
    badge.setBadge(parsedDate);
    return badge;
  }

  @override
  String get name => 'Gold';
}

class RettungsschwimmerBronzeBadge extends Badge {
  RettungsschwimmerBronzeBadge();

  factory RettungsschwimmerBronzeBadge.fromJson(dynamic json) {
    final badge = RettungsschwimmerBronzeBadge();
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return badge;
    }
    badge.setBadge(parsedDate);
    return badge;
  }

  @override
  String get name => 'RettungsschwimmerBronze';
}

class RettungsschwimmerSilverBadge extends Badge {
  RettungsschwimmerSilverBadge();

  factory RettungsschwimmerSilverBadge.fromJson(dynamic json) {
    final badge = RettungsschwimmerSilverBadge();
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return badge;
    }
    badge.setBadge(parsedDate);
    return badge;
  }

  @override
  String get name => 'RettungsschwimmerSilber';
}

class RettungsschwimmerGoldBadge extends Badge {
  RettungsschwimmerGoldBadge();

  factory RettungsschwimmerGoldBadge.fromJson(dynamic json) {
    final badge = RettungsschwimmerGoldBadge();
    final parsedDate = Badge.parseDateFromJson(json);
    if (parsedDate == null) {
      return badge;
    }
    badge.setBadge(parsedDate);
    return badge;
  }

  @override
  String get name => 'RettungsschwimmerGold';
}
