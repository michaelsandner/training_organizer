import 'package:flutter/material.dart';

abstract class AbstractQualification {
  DateTime? date;

  AbstractQualification(this.date);

  String get name;
  String get fullName;
  String get shortName;

  Icon get icon;
  String? get iconName;

  bool isUp2Date() {
    return true;
  }
}
