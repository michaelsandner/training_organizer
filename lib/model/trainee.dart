import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/badge.dart';

class Trainee {
  final String surname;
  final String forename;
  final String email;
  final String dateOfBirth;
  final FilterableGroup? trainingGroup;
  final String phone;
  final String comment;
  final bool isMember;
  final Badge? badge;

  Trainee({
    this.surname = '',
    this.forename = '',
    this.email = '',
    this.dateOfBirth = '',
    this.trainingGroup,
    this.phone = '',
    this.comment = '',
    this.isMember = false,
    this.badge,
  });

  factory Trainee.fromJson(dynamic json) {
    return Trainee(
        surname: json['surname'] ?? '',
        forename: json['forename'] ?? '',
        email: json['email'] ?? '',
        dateOfBirth: json['dateOfBirth'] ?? '',
        phone: json['phone'] ?? '',
        trainingGroup: mapGroupToEnum(json['trainingGroup']),
        comment: json['comment'] ?? '',
        isMember: json['isMember'] ?? false,
        badge: json['badge'] == null ? null : mapBadge(json['badge']));
  }

  String get groupShortName {
    switch (trainingGroup) {
      case FilterableGroup.waitingList:
        return 'W';
      case FilterableGroup.group1:
        return '1';
      case FilterableGroup.group2:
        return '2';
      case FilterableGroup.group3:
        return '3';
      case FilterableGroup.group4:
        return '4';
      case FilterableGroup.group5:
        return '5';
      case FilterableGroup.wednesday:
        return 'M';
      case FilterableGroup.active:
        return 'A';
      default:
        return '';
    }
  }

  String get groupName {
    switch (trainingGroup) {
      case FilterableGroup.waitingList:
        return 'Warteliste';
      case FilterableGroup.group1:
        return 'Block 1';
      case FilterableGroup.group2:
        return 'Block 2';
      case FilterableGroup.group3:
        return 'Block 3';
      case FilterableGroup.group4:
        return 'Block 4';
      case FilterableGroup.group5:
        return 'Block 5';
      case FilterableGroup.wednesday:
        return 'Mittwoch';
      case FilterableGroup.active:
        return 'Aktiv';
      default:
        return '';
    }
  }

  static Badge? mapBadge(Map<String, dynamic> badge) {
    switch (badge['name']) {
      case 'Bronze':
        return BronzeBadge.fromJson(badge);
      case 'Silber':
        return SilverBadge.fromJson(badge);
      case 'Gold':
        return GoldBadge.fromJson(badge);
      case 'RettungsschwimmerBronze':
        return RettungsschwimmerBronzeBadge.fromJson(badge);
      case 'RettungsschwimmerSilber':
        return RettungsschwimmerSilverBadge.fromJson(badge);
      case 'RettungsschwimmerGold':
        return RettungsschwimmerBronzeBadge.fromJson(badge);
      default:
        return null;
    }
  }

  static FilterableGroup? mapGroupToEnum(String? groupName) {
    switch (groupName) {
      case 'waitingList':
        return FilterableGroup.waitingList;
      case 'group5':
        return FilterableGroup.group5;
      case 'group4':
        return FilterableGroup.group4;
      case 'group3':
        return FilterableGroup.group3;
      case 'group2':
        return FilterableGroup.group2;
      case 'group1':
        return FilterableGroup.group1;
      case 'wednesday':
        return FilterableGroup.wednesday;
      case 'active':
        return FilterableGroup.active;
      default:
        return null;
    }
  }

  Trainee copyWith({
    FilterableGroup? trainingGroup,
    String? email,
    String? phone,
    String? comment,
    bool? isMember,
    Badge? badge,
  }) {
    return Trainee(
      dateOfBirth: dateOfBirth,
      surname: surname,
      forename: forename,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      trainingGroup: trainingGroup ?? this.trainingGroup,
      comment: comment ?? this.comment,
      isMember: isMember ?? this.isMember,
      badge: badge ?? this.badge,
    );
  }

  Trainee copyWithNewGroup(FilterableGroup group) {
    return Trainee(
      dateOfBirth: dateOfBirth,
      surname: surname,
      forename: forename,
      email: email,
      phone: phone,
      trainingGroup: group,
      badge: badge,
    );
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
        'phone': phone,
        'trainingGroup': getTrainingGroupValue(),
        'comment': comment,
        'isMember': isMember,
        'badge': badge == null ? null : badge!.toJson(),
      };

  String? getTrainingGroupValue() {
    if (trainingGroup != null) {
      return trainingGroup.toString().split('.').last;
    }
    return null;
  }
}
