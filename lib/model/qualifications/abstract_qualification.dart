import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class AbstractQualification {
  DateTime? date;

  AbstractQualification(this.date);

  String get name;
  String get fullName;
  String get shortName;

  Icon get icon;
  String? get iconName;

  bool get isUp2Date => true;

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date == null ? null : _parseDateTimeToString(date!),
      };

  static String _parseDateTimeToString(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
