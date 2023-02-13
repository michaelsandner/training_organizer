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

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date == null ? null : date!.toString(),
      };
}

class BronzeBadge extends Badge {
  BronzeBadge();

  factory BronzeBadge.fromJson(dynamic json) {
    final badge = BronzeBadge();
    if (json['date'] != null) {
      final date = DateTime.parse(json['date']);
      badge.setBadge(date);
    }

    return badge;
  }

  @override
  String get name => 'Bronze';
}

class SilverBadge extends Badge {
  SilverBadge();

  factory SilverBadge.fromJson(dynamic json) {
    final badge = SilverBadge();
    if (json['date'] != null) {
      final date = DateTime.parse(json['date']);
      badge.setBadge(date);
    }

    return badge;
  }

  @override
  String get name => 'Silber';
}

class GoldBadge extends Badge {
  GoldBadge();

  factory GoldBadge.fromJson(dynamic json) {
    final badge = GoldBadge();
    if (json['date'] != null) {
      final date = DateTime.parse(json['date']);
      badge.setBadge(date);
    }

    return badge;
  }

  @override
  String get name => 'Gold';
}

class RettungsschwimmerBronzeBadge extends Badge {
  RettungsschwimmerBronzeBadge();

  factory RettungsschwimmerBronzeBadge.fromJson(dynamic json) {
    final badge = RettungsschwimmerBronzeBadge();
    if (json['date'] != null) {
      final date = DateTime.parse(json['date']);
      badge.setBadge(date);
    }

    return badge;
  }

  @override
  String get name => 'RettungsschwimmerBronze';
}

class RettungsschwimmerSilverBadge extends Badge {
  RettungsschwimmerSilverBadge();

  factory RettungsschwimmerSilverBadge.fromJson(dynamic json) {
    final badge = RettungsschwimmerSilverBadge();
    if (json['date'] != null) {
      final date = DateTime.parse(json['date']);
      badge.setBadge(date);
    }

    return badge;
  }

  @override
  String get name => 'RettungsschwimmerSilber';
}

class RettungsschwimmerGoldBadge extends Badge {
  RettungsschwimmerGoldBadge();

  factory RettungsschwimmerGoldBadge.fromJson(dynamic json) {
    final badge = RettungsschwimmerGoldBadge();
    if (json['date'] != null) {
      final date = DateTime.parse(json['date']);
      badge.setBadge(date);
    }

    return badge;
  }

  @override
  String get name => 'RettungsschwimmerGold';
}
