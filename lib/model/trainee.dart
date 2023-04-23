import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/badge.dart';

class Trainee {
  final String surname;
  final String forename;
  final String email;
  final String dateOfBirth;
  final String registrationDate;
  final Group trainingGroup;
  final String phone;
  final String comment;
  final bool isMember;
  final Badge? badge;
  final List<Badge?> badges;
  final bool isTrainer;

  Trainee({
    this.surname = '',
    this.forename = '',
    this.email = '',
    this.dateOfBirth = '',
    this.registrationDate = '',
    this.trainingGroup = Group.waitingList,
    this.phone = '',
    this.comment = '',
    this.isMember = false,
    this.badge,
    this.badges = const [],
    this.isTrainer = false,
  });

  factory Trainee.fromJson(dynamic json) {
    return Trainee(
      surname: json['surname'] ?? '',
      forename: json['forename'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: json['dateOfBirth'] == null ||
              json['dateOfBirth'] == '0' ||
              json['dateOfBirth'] == 'null'
          ? ''
          : json['dateOfBirth'],
      registrationDate: json['registrationDate'] ?? '',
      phone: json['phone'] == null ||
              json['phone'] == '0' ||
              json['phone'] == 'null'
          ? ''
          : json['phone'],
      trainingGroup: mapGroupToEnum(json['trainingGroup']),
      comment: json['comment'] ?? '',
      isMember: json['isMember'] ?? false,
      badge: json['badge'] == null ? null : mapBadge(json['badge']),
      badges: json['badges'] == null ? [] : mapBadges(json['badges']),
      isTrainer: json['isTrainer'] ?? false,
    );
  }

  String get groupShortName {
    switch (trainingGroup) {
      case Group.waitingList:
        return 'W';
      case Group.group1:
        return '1';
      case Group.group2:
        return '2';
      case Group.group3:
        return '3';
      case Group.group4:
        return '4';
      case Group.group5:
        return '5';
      case Group.wednesday:
        return 'M';
      case Group.active:
        return 'A';
      default:
        return '';
    }
  }

  String get groupName {
    switch (trainingGroup) {
      case Group.waitingList:
        return 'Warteliste';
      case Group.group1:
        return 'Block 1';
      case Group.group2:
        return 'Block 2';
      case Group.group3:
        return 'Block 3';
      case Group.group4:
        return 'Block 4';
      case Group.group5:
        return 'Block 5';
      case Group.wednesday:
        return 'Mittwoch';
      case Group.active:
        return 'Aktiv';
      default:
        return '';
    }
  }

  bool hasBadgeFromYear(String badgeName, int year) {
    for (var element in badges) {
      if (element != null &&
          element.name == badgeName &&
          element.date != null &&
          element.date!.year == year) {
        return true;
      }
    }
    return false;
  }

  bool hasBadge(String badgeName) {
    for (var element in badges) {
      if (element != null && element.name == badgeName) {
        if (element.name == 'RettungsschwimmerSilber' && !element.isUpToDate) {
          return false;
        }
        return true;
      }
    }
    return false;
  }

  String getHighestBadge() {
    if (badges.isEmpty) {
      return '';
    }
    if (badges.any((element) => element is GoldBadge)) {
      return 'G';
    }
    if (badges.any((element) => element is SilverBadge)) {
      return 'S';
    }
    if (badges.any((element) => element is BronzeBadge)) {
      return 'B';
    }
    if (badges.any((element) => element is PirateBadge)) {
      return 'P';
    }
    return '';
  }

  static List<Badge?> mapBadges(List<dynamic> badges) {
    List<Badge?> listOfBadges = [];
    for (var element in badges) {
      listOfBadges.add(mapBadge(element));
    }
    return listOfBadges;
  }

  static Badge? mapBadge(Map<String, dynamic> badge) {
    final badgeFactory = BadgeFactory();
    return badgeFactory.getBadge(badge);
  }

  static Group mapGroupToEnum(String? groupName) {
    switch (groupName) {
      case 'waitingList':
        return Group.waitingList;
      case 'invited':
        return Group.invited;
      case 'group5':
        return Group.group5;
      case 'group4':
        return Group.group4;
      case 'group3':
        return Group.group3;
      case 'group2':
        return Group.group2;
      case 'group1':
        return Group.group1;
      case 'wednesday':
        return Group.wednesday;
      case 'active':
        return Group.active;
      default:
        return Group.waitingList;
    }
  }

  Trainee copyWith({
    Group? trainingGroup,
    String? email,
    String? phone,
    String? comment,
    bool? isMember,
    Badge? badge,
    String? dateOfBirth,
    String? registrationDate,
    bool? isTrainer,
  }) {
    return Trainee(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      registrationDate: registrationDate ?? this.registrationDate,
      surname: surname,
      forename: forename,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      trainingGroup: trainingGroup ?? this.trainingGroup,
      comment: comment ?? this.comment,
      isMember: isMember ?? this.isMember,
      badge: badge ?? this.badge,
      isTrainer: isTrainer ?? this.isTrainer,
    );
  }

  Trainee copyWithNewGroup(Group group) {
    return Trainee(
        dateOfBirth: dateOfBirth,
        registrationDate: registrationDate,
        surname: surname,
        forename: forename,
        email: email,
        phone: phone,
        trainingGroup: group,
        badge: badge,
        isTrainer: isTrainer,
        comment: comment);
  }

  @override
  bool operator ==(Object other) =>
      other is Trainee &&
      other.forename == forename &&
      other.surname == surname;

  @override
  int get hashCode => Object.hash(forename, surname, email);

  Map<String, dynamic> toJson() => {
        'surname': surname,
        'forename': forename,
        'email': email,
        'dateOfBirth': dateOfBirth,
        'registrationDate': registrationDate,
        'phone': phone,
        'trainingGroup': getTrainingGroupValue(),
        'comment': comment,
        'isMember': isMember,
        'badge': badge == null ? null : badge!.toJson(),
        'badges': mapBadgesToJson(badges),
        'isTrainer': isTrainer,
      };

  List<Map<String, dynamic>> mapBadgesToJson(List<Badge?> badges) {
    List<Map<String, dynamic>> badgesAsJson = [];

    for (var element in badges) {
      if (element != null) {
        badgesAsJson.add(element.toJson());
      }
    }

    return badgesAsJson;
  }

  String getTrainingGroupValue() {
    return trainingGroup.toString().split('.').last;
  }
}
