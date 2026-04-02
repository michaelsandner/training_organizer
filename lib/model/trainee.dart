import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/qualifications.dart';

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
  final Qualifications qualifications;
  final bool isTrainer;
  final Map<String, List<DateTime>> attendanceDates;

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
    this.qualifications = const Qualifications(),
    this.isTrainer = false,
    this.attendanceDates = const {},
  });

  List<DateTime> get allAttendanceDates =>
      attendanceDates.values.expand((dates) => dates).toList();

  List<DateTime> attendanceDatesForGroup(String groupKey) =>
      attendanceDates[groupKey] ?? [];

  factory Trainee.fromJson(dynamic json) {
    final group = mapGroupToEnum(json['trainingGroup']);
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
      trainingGroup: group,
      comment: json['comment'] ?? '',
      isMember: json['isMember'] ?? false,
      qualifications: Qualifications.fromJson(json['qualifications']),
      isTrainer: json['isTrainer'] ?? false,
      attendanceDates: _parseAttendanceDates(json['attendanceDates'], group),
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
      case Group.leisure:
        return 'Freizeit';
      default:
        return '';
    }
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
      case 'leisure':
        return Group.leisure;
      default:
        return Group.waitingList;
    }
  }

  static final DateFormat _germanDateFormat = DateFormat('dd.MM.yyyy');

  static Map<String, List<DateTime>> _parseAttendanceDates(
      dynamic dates, Group group) {
    if (dates == null) return {};
    if (dates is Map) {
      return _parseGroupedAttendanceDates(dates);
    }
    if (dates is List) {
      return _parseFlatAttendanceDates(dates, group);
    }
    return {};
  }

  static Map<String, List<DateTime>> _parseGroupedAttendanceDates(
      Map<dynamic, dynamic> dates) {
    final result = <String, List<DateTime>>{};
    for (final entry in dates.entries) {
      final groupKey = entry.key.toString();
      final dateList = entry.value;
      if (dateList is List) {
        final parsed = <DateTime>[];
        for (final d in dateList) {
          final date = _tryParseDate(d);
          if (date != null) {
            parsed.add(date);
          }
        }
        if (parsed.isNotEmpty) {
          result[groupKey] = parsed;
        }
      }
    }
    return result;
  }

  static Map<String, List<DateTime>> _parseFlatAttendanceDates(
      List<dynamic> dates, Group group) {
    final parsed = <DateTime>[];
    for (final d in dates) {
      final date = _tryParseDate(d);
      if (date != null) {
        parsed.add(date);
      }
    }
    if (parsed.isEmpty) return {};
    final groupKey = group.toString().split('.').last;
    return {groupKey: parsed};
  }

  static DateTime? _tryParseDate(dynamic d) {
    if (d is String) {
      final iso = DateTime.tryParse(d);
      if (iso != null) return iso;
      try {
        return _germanDateFormat.parse(d);
      } catch (_) {
        return null;
      }
    }
    if (d is int) {
      return DateTime.fromMillisecondsSinceEpoch(d);
    }
    return null;
  }

  Trainee copyWith({
    Group? trainingGroup,
    String? email,
    String? phone,
    String? comment,
    bool? isMember,
    Qualifications? qualifications,
    String? dateOfBirth,
    String? registrationDate,
    bool? isTrainer,
    Map<String, List<DateTime>>? attendanceDates,
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
      qualifications: qualifications ?? this.qualifications,
      isTrainer: isTrainer ?? this.isTrainer,
      attendanceDates: attendanceDates ?? this.attendanceDates,
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
        qualifications: qualifications,
        isTrainer: isTrainer,
        comment: comment,
        isMember: isMember,
        attendanceDates: attendanceDates);
  }

  @override
  bool operator ==(Object other) =>
      other is Trainee &&
      other.forename == forename &&
      other.surname == surname &&
      other.email == email &&
      other.phone == phone &&
      other.dateOfBirth == dateOfBirth &&
      other.registrationDate == registrationDate &&
      other.trainingGroup == trainingGroup &&
      other.isMember == isMember &&
      other.isTrainer == isTrainer &&
      other.comment == comment &&
      other.qualifications == qualifications &&
      _attendanceDatesEqual(other.attendanceDates, attendanceDates);

  static bool _attendanceDatesEqual(
    Map<String, List<DateTime>> a,
    Map<String, List<DateTime>> b,
  ) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;
      if (!listEquals(a[key], b[key])) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        forename,
        surname,
        email,
        phone,
        trainingGroup,
        isMember,
        isTrainer,
        Object.hashAllUnordered(
          attendanceDates.entries
              .map((e) => Object.hash(e.key, Object.hashAll(e.value))),
        ),
      );

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
        'qualifications': qualifications.toJson()['qualifications'],
        'isTrainer': isTrainer,
        'attendanceDates': attendanceDates.map(
          (groupKey, dates) => MapEntry(
            groupKey,
            dates.map((d) => d.toIso8601String().split('T')[0]).toList(),
          ),
        ),
      };

  String getTrainingGroupValue() {
    return trainingGroup.toString().split('.').last;
  }
}
