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
  Qualification? getqualification(Map<String, dynamic> json) {
    DateTime? parsedDate = parseDateFromJson(json);
    QualificationType? qualificationType = getqualificationType(json);

    if (qualificationType != null) {
      return Qualification(
          date: parsedDate, qualificationType: qualificationType);
    }
    return null;
  }

  QualificationType? getqualificationType(Map<String, dynamic> json) {
    switch (json['name']) {
      case 'Pirate':
        return QualificationType.pirate;
      case 'Bronze':
        return QualificationType.bronze;
      case 'Silber':
        return QualificationType.silber;
      case 'Gold':
        return QualificationType.gold;
      case 'RettungsschwimmerBronze':
        return QualificationType.rettungschwimmerBronze;
      case 'RettungsschwimmerSilber':
        return QualificationType.rettungsschwimmerSilber;
      case 'RettungsschwimmerGold':
        return QualificationType.rettungsschwimmerGold;
      case 'Wasserretter':
        return QualificationType.wassserretter;
      case 'San':
        return QualificationType.san;
      case 'RSiWRD':
        return QualificationType.rettungsschwimmerImWasserrettungsdienst;
      case 'Ausbildungsassistent':
        return QualificationType.ausbildungsassistent;
      case 'AusbilderS1':
        return QualificationType.ausbilderS1;
      case 'AusbilderS2':
        return QualificationType.ausbilderS2;
      case 'AusbilderR1':
        return QualificationType.ausbilderR1;
      case 'AusbilderR2':
        return QualificationType.ausbilderR2;
      case 'Gruppenleiter':
        return QualificationType.gruppenleiter;
      default:
        return null;
    }
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
