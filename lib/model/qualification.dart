import 'package:intl/intl.dart';
import 'package:training_organizer/model/qualification_type.dart';

class Qualification {
  final DateTime? date;
  final QualificationType qualificationType;

  Qualification({
    this.date,
    required this.qualificationType,
  });

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

  static String parseDateTimeToString(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  Map<String, dynamic> toJson() => {
        'name': qualificationType.name,
        'date': date == null ? null : parseDateTimeToString(date!),
      };
}

class QualificationFactory {
  Qualification? getQualification(Map<String, dynamic> json) {
    DateTime? parsedDate = parseDateFromJson(json);
    QualificationType? qualificationType = getQualificationType(json);

    if (qualificationType != null) {
      return Qualification(
          date: parsedDate, qualificationType: qualificationType);
    }
    return null;
  }

  QualificationType? getQualificationType(Map<String, dynamic> json) {
    final name = json['name'];

    for (var qualificationType in QualificationType.values) {
      if (name == qualificationType.name) {
        return qualificationType;
      }
    }
    return null;
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
}
