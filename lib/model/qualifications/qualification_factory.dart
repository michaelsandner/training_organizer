import 'package:intl/intl.dart';
import 'package:training_organizer/model/qualifications/assitent.dart';
import 'package:training_organizer/model/qualifications/ausbilder_r1.dart';
import 'package:training_organizer/model/qualifications/ausbilder_r2.dart';
import 'package:training_organizer/model/qualifications/ausbilder_s1.dart';
import 'package:training_organizer/model/qualifications/ausbilder_s2.dart';
import 'package:training_organizer/model/qualifications/fachsan.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/gruppenleiter.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/rettsan.dart';
import 'package:training_organizer/model/qualifications/rs_bronze.dart';
import 'package:training_organizer/model/qualifications/rs_gold.dart';
import 'package:training_organizer/model/qualifications/rs_silber.dart';
import 'package:training_organizer/model/qualifications/rsiwrd.dart';
import 'package:training_organizer/model/qualifications/san.dart';
import 'package:training_organizer/model/qualifications/silber.dart';
import 'package:training_organizer/model/qualifications/wasserretter.dart';

import 'abstract_qualification.dart';
import 'bronze.dart';

const String pirat = 'Pirat';
const String bronze = 'Bronze';
const String silber = 'Silber';
const String gold = 'Gold';
const String rettungsschwimmerBronze = 'RettungsschwimmerBronze';
const String rettungsschwimmerSilber = 'RettungsschwimmerSilber';
const String rettungsschwimmerGold = 'RettungsschwimmerGold';
const String rsiwrd = 'RSiWRD';
const String san = 'San';
const String fachsan = 'FachSan';
const String rettsan = 'RettSan';
const String wasserretter = 'Wasserretter';
const String ausbildungsAssistent = 'Ausbildungsassistent';
const String ausbilderS1 = 'AusbilderS1';
const String ausbilderS2 = 'AusbilderS2';
const String ausbilderR1 = 'AusbilderR1';
const String ausbilderR2 = 'AusbilderR2';
const String gruppenleiter = 'Gruppenleiter';

class QualificationFactory {
  List<AbstractQualification> createQualifications(
      List<dynamic> qualifications) {
    List<AbstractQualification> result = [];

    for (var element in qualifications) {
      DateTime? parsedDate = parseDateFromJson(element);
      final name = element['name'];

      result.add(_createQualification(name, parsedDate));
    }

    return result;
  }

  AbstractQualification _createQualification(String name, DateTime? date) {
    switch (name) {
      case pirat:
        return Pirat(date);
      case bronze:
        return Bronze(date);
      case silber:
        return Silber(date);
      case gold:
        return Gold(date);
      case rettungsschwimmerBronze:
        return RsBronze(date);
      case rettungsschwimmerSilber:
        return RsSilber(date);
      case rettungsschwimmerGold:
        return RsGold(date);
      case rsiwrd:
        return RSiWRD(date);
      case san:
        return San(date);
      case fachsan:
        return FachSan(date);
      case rettsan:
        return RettSan(date);
      case wasserretter:
        return Wasserretter(date);
      case ausbildungsAssistent:
        return Assistent(date);
      case ausbilderS1:
        return AusbilderS1(date);
      case ausbilderS2:
        return AusbilderS2(date);
      case ausbilderR1:
        return AusbilderR1(date);
      case ausbilderR2:
        return AusbilderR2(date);
      case gruppenleiter:
        return Gruppenleiter(date);
      default:
    }

    throw ArgumentError('$name is not a qualification');
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
