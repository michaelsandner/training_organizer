import 'package:training_organizer/app_state.dart';

class Trainee {
  final String surname;
  final String forename;
  final String email;
  final String dateOfBirth;
  final Group? trainingGroup;
  final String phone;

  Trainee({
    this.surname = '',
    this.forename = '',
    this.email = '',
    this.dateOfBirth = '',
    this.trainingGroup,
    this.phone = '',
  });

  factory Trainee.fromJson(dynamic json) {
    return Trainee(
        surname: json['surname'] ?? '',
        forename: json['forename'] ?? '',
        email: json['email'] ?? '',
        dateOfBirth: json['dateOfBirth'] ?? '',
        phone: json['phone'] ?? '',
        trainingGroup: mapGroupToEnum(json['trainingGroup']));
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

  static Group? mapGroupToEnum(String? groupName) {
    switch (groupName) {
      case 'waitingList':
        return Group.waitingList;
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
        return null;
    }
  }

  Trainee copyWithNewGroup(Group group) {
    return Trainee(
      dateOfBirth: dateOfBirth,
      surname: surname,
      forename: forename,
      email: email,
      phone: phone,
      trainingGroup: group,
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
      };

  String? getTrainingGroupValue() {
    if (trainingGroup != null) {
      return trainingGroup.toString().split('.').last;
    }
    return null;
  }
}
