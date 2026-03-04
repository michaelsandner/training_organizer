import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_organizer/model/qualifications/qualification_validity.dart';

abstract class Qualification {
  DateTime? date;

  Qualification(this.date);

  String get name;
  String get fullName;
  String get shortName;

  Icon get icon;
  String? get iconName;

  QualificationValidity get isUp2Date => QualificationValidity.valid;

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date == null ? null : _parseDateTimeToString(date!),
      };

  static String _parseDateTimeToString(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  bool operator ==(Object other) =>
      other is Qualification && other.name == name && other.date == date;

  @override
  int get hashCode => Object.hash(name, date);
}
