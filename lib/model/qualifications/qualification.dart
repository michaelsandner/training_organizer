import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_organizer/model/qualifications/qualification_validity.dart';

abstract class Qualification {
  DateTime? date;
  bool isAchievedIntern;

  Qualification(this.date, {this.isAchievedIntern = true});

  String get name;
  String get fullName;
  String get shortName;

  Icon get icon;
  String? get iconName;

  QualificationValidity get isUp2Date => QualificationValidity.valid;

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date == null ? null : _parseDateTimeToString(date!),
        'isAchievedIntern': isAchievedIntern,
      };

  static String _parseDateTimeToString(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  bool operator ==(Object other) =>
      other is Qualification &&
      other.name == name &&
      other.date == date &&
      other.isAchievedIntern == isAchievedIntern;

  @override
  int get hashCode => Object.hash(name, date, isAchievedIntern);
}
