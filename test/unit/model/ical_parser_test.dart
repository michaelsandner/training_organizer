import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/ical_import_result.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/ical_parser.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/dienstabend_rule.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/oeffentlichkeitsarbeit_rule.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/rettungsschwimmausbildung_rule.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/san_dienst_rule.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/schwimmtraining_rule.dart';

int _getApplyValue(IcalImportResult result, String categoryName) {
  return result.applyEntries
      .where((e) => e.targetCategoryName == categoryName)
      .fold(0, (sum, e) => sum + e.value);
}

int _getDisplayValue(IcalImportResult result, String label) {
  return result.displayRows
      .where((e) => e.label == label)
      .fold(0, (sum, e) => sum + e.value);
}

void main() {
  late IcalParser sut;

  setUp(() {
    sut = IcalParser();
  });

  group('IcalParser', () {
    group('Given eine iCal-Datei mit Schwimmtraining-Terminen', () {
      group('When parse mit dem richtigen Jahr aufgerufen wird', () {
        test('Then werden exakte Treffer von Schwimmtraining gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260420T150000Z
DTEND:20260420T160000Z
SUMMARY:Schwimmtraining
END:VEVENT
BEGIN:VEVENT
DTSTART:20260427T150000Z
DTEND:20260427T160000Z
SUMMARY:Schwimmtraining
END:VEVENT
BEGIN:VEVENT
DTSTART:20260504T150000Z
DTEND:20260504T160000Z
SUMMARY:Kein Schwimmtraining (Sommerferien)
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            2,
          );
        });
      });

      group('When parse mit einem anderen Jahr aufgerufen wird', () {
        test('Then werden keine Treffer gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260420T150000Z
DTEND:20260420T160000Z
SUMMARY:Schwimmtraining
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2025);

          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            0,
          );
        });
      });
    });

    group('Given eine iCal-Datei mit San-Dienst-Terminen', () {
      group('When parse aufgerufen wird', () {
        test('Then werden Treffer die San-Dienst enthalten gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260601T080000Z
DTEND:20260601T170000Z
SUMMARY:San-Dienst Klosterhofspiele
END:VEVENT
BEGIN:VEVENT
DTSTART:20260615T080000Z
DTEND:20260615T170000Z
SUMMARY:San-Dienst
END:VEVENT
BEGIN:VEVENT
DTSTART:20260620T080000Z
DTEND:20260620T170000Z
SUMMARY:SanitÃ¤tsausbildung
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, SanDienstRule.targetCategoryAnzahl),
            2,
          );
        });
      });
    });

    group('Given eine iCal-Datei mit Zeitzonen-DTSTART', () {
      group('When parse aufgerufen wird', () {
        test('Then wird das Jahr korrekt erkannt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260801T160000
DTEND;TZID=Europe/Berlin:20260801T165500
SUMMARY:Schwimmtraining
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            1,
          );
        });
      });
    });

    group('Given eine iCal-Datei mit DATE-only DTSTART', () {
      group('When parse aufgerufen wird', () {
        test('Then wird das Jahr korrekt erkannt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART;VALUE=DATE:20260518
DTEND;VALUE=DATE:20260519
SUMMARY:San-Dienst Volksfest
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, SanDienstRule.targetCategoryAnzahl),
            1,
          );
        });
      });
    });

    group('Given eine leere iCal-Datei', () {
      group('When parse aufgerufen wird', () {
        test('Then sind alle ZÃ¤hler 0', () {
          const ical = '''
BEGIN:VCALENDAR
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            0,
          );
          expect(
            _getApplyValue(result, SanDienstRule.targetCategoryAnzahl),
            0,
          );
          expect(
            _getApplyValue(result, DienstabendRule.targetCategory),
            0,
          );
        });
      });
    });

    group('Given eine iCal-Datei mit gemischten Terminen', () {
      group('When parse aufgerufen wird', () {
        test('Then werden alle Positionen korrekt gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260420T150000Z
SUMMARY:Schwimmtraining
END:VEVENT
BEGIN:VEVENT
DTSTART:20260427T150000Z
SUMMARY:Schwimmtraining
END:VEVENT
BEGIN:VEVENT
DTSTART:20260504T150000Z
SUMMARY:Schwimmtraining
END:VEVENT
BEGIN:VEVENT
DTSTART:20260601T080000Z
SUMMARY:San-Dienst Klosterhofspiele
END:VEVENT
BEGIN:VEVENT
DTSTART:20260615T080000Z
SUMMARY:San-Dienst Musical
END:VEVENT
BEGIN:VEVENT
DTSTART:20260620T080000Z
SUMMARY:JHV
END:VEVENT
BEGIN:VEVENT
DTSTART:20250420T150000Z
SUMMARY:Schwimmtraining
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            3,
          );
          expect(
            _getApplyValue(result, SanDienstRule.targetCategoryAnzahl),
            2,
          );
        });
      });
    });

    group('Given eine iCal-Datei mit Line-Folding', () {
      group('When parse aufgerufen wird', () {
        test('Then werden gefaltete Zeilen korrekt zusammengefÃ¼gt', () {
          const ical =
              'BEGIN:VCALENDAR\r\nBEGIN:VEVENT\r\nDTSTART:20260420T150000Z\r\nSUMMARY:Schwimm\r\n training\r\nEND:VEVENT\r\nEND:VCALENDAR';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            1,
          );
        });
      });
    });

    group('Given eine iCal-Datei mit wÃ¶chentlicher Schwimmtraining-Serie', () {
      group('When parse aufgerufen wird', () {
        test('Then werden alle Termine der Serie im Jahr gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260106T200000
DTEND;TZID=Europe/Berlin:20260106T210000
RRULE:FREQ=WEEKLY;UNTIL=20260224T225959Z;BYDAY=TU
UID:weekly-test@test.com
SUMMARY:Schwimmtraining
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // 06.01, 13.01, 20.01, 27.01, 03.02, 10.02, 17.02, 24.02 = 8
          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            8,
          );
        });
      });
    });

    group('Given eine Serie mit EXDATE-AusschlÃ¼ssen', () {
      group('When parse aufgerufen wird', () {
        test('Then werden ausgeschlossene Termine nicht gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260106T200000
DTEND;TZID=Europe/Berlin:20260106T210000
RRULE:FREQ=WEEKLY;UNTIL=20260224T225959Z;BYDAY=TU
EXDATE;TZID=Europe/Berlin:20260113T200000
EXDATE;TZID=Europe/Berlin:20260127T200000
UID:weekly-exdate@test.com
SUMMARY:Schwimmtraining
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // 8 total minus 2 EXDATE = 6
          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            6,
          );
        });
      });
    });

    group('Given eine Serie mit RECURRENCE-ID Ãœberschreibungen', () {
      group('When eine Instanz durch Nicht-Schwimmtraining ersetzt wird', () {
        test('Then wird die Ã¼berschriebene Instanz nicht gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260106T200000
DTEND;TZID=Europe/Berlin:20260106T210000
RRULE:FREQ=WEEKLY;UNTIL=20260127T225959Z;BYDAY=TU
UID:weekly-override@test.com
SUMMARY:Schwimmtraining
END:VEVENT
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260113T200000
DTEND;TZID=Europe/Berlin:20260113T210000
UID:weekly-override@test.com
RECURRENCE-ID;TZID=Europe/Berlin:20260113T200000
SUMMARY:Kein Schwimmtraining (Feiertag)
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // 4 weeks (06, 13, 20, 27), 13th overridden = 3
          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            3,
          );
        });
      });

      group('When eine Instanz durch Schwimmtraining ersetzt wird', () {
        test('Then wird die Ã¼berschriebene Instanz gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260106T200000
DTEND;TZID=Europe/Berlin:20260106T210000
RRULE:FREQ=WEEKLY;UNTIL=20260127T225959Z;BYDAY=TU
UID:weekly-override2@test.com
SUMMARY:Schwimmtraining
END:VEVENT
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260113T200000
DTEND;TZID=Europe/Berlin:20260113T210000
UID:weekly-override2@test.com
RECURRENCE-ID;TZID=Europe/Berlin:20260113T200000
SUMMARY:Schwimmtraining
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // 4 weeks, 1 override with same summary = still 4
          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            4,
          );
        });
      });
    });

    group('Given eine Serie die in einem Vorjahr startet', () {
      group('When parse fÃ¼r das Folgejahr aufgerufen wird', () {
        test('Then werden nur Termine des gewÃ¤hlten Jahres gezÃ¤hlt', () {
          // Start 01.12.2025, weekly, until 19.01.2026
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20251201T200000
DTEND;TZID=Europe/Berlin:20251201T210000
RRULE:FREQ=WEEKLY;UNTIL=20260119T225959Z;BYDAY=MO
UID:cross-year@test.com
SUMMARY:Schwimmtraining
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // 2026: 05.01, 12.01, 19.01 = 3
          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            3,
          );
        });
      });
    });

    group('Given eine offene Serie ohne UNTIL', () {
      group('When parse aufgerufen wird', () {
        test('Then werden alle Termine im gewÃ¤hlten Jahr gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260103T160000
DTEND;TZID=Europe/Berlin:20260103T165500
RRULE:FREQ=WEEKLY;BYDAY=SA
UID:open-ended@test.com
SUMMARY:Schwimmtraining
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // 52 Saturdays in 2026 (03.01 to 26.12)
          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            52,
          );
        });
      });
    });

    group('Given eine Serie mit COUNT-Begrenzung', () {
      group('When parse aufgerufen wird', () {
        test('Then werden nur so viele Termine wie COUNT gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260106T200000
DTEND;TZID=Europe/Berlin:20260106T210000
RRULE:FREQ=WEEKLY;COUNT=3;BYDAY=TU
UID:count-test@test.com
SUMMARY:Schwimmtraining
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // 06.01, 13.01, 20.01 = 3
          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            3,
          );
        });
      });
    });

    group('Given eine Serie mit EXDATE und RECURRENCE-ID kombiniert', () {
      group('When parse aufgerufen wird', () {
        test('Then werden EXDATE und Overrides korrekt berÃ¼cksichtigt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260106T200000
DTEND;TZID=Europe/Berlin:20260106T210000
RRULE:FREQ=WEEKLY;UNTIL=20260224T225959Z;BYDAY=TU
EXDATE;TZID=Europe/Berlin:20260120T200000
EXDATE;TZID=Europe/Berlin:20260203T200000
UID:combined@test.com
SUMMARY:Schwimmtraining
END:VEVENT
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:20260210T200000
DTEND;TZID=Europe/Berlin:20260210T210000
UID:combined@test.com
RECURRENCE-ID;TZID=Europe/Berlin:20260210T200000
SUMMARY:Freies Training
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // 8 weeks - 2 EXDATE - 1 override (different summary) = 5
          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            5,
          );
        });
      });
    });

    group('Given eine iCal-Datei mit Dienstabend-Terminen', () {
      group('When parse aufgerufen wird', () {
        test('Then werden nur exakte Treffer von Dienstabend gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260115T190000Z
DTEND:20260115T210000Z
SUMMARY:Dienstabend
END:VEVENT
BEGIN:VEVENT
DTSTART:20260212T190000Z
DTEND:20260212T210000Z
SUMMARY:Dienstabend
END:VEVENT
BEGIN:VEVENT
DTSTART:20260305T190000Z
DTEND:20260305T210000Z
SUMMARY:Dienstabend FÃ¼rth - VerbÃ¤nde (intern)
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // Only exact matches, not "Dienstabend FÃ¼rth..."
          expect(
            _getApplyValue(result, DienstabendRule.targetCategory),
            2,
          );
        });
      });
    });

    group('Given Dienstabend-Termine mit Namen in der Beschreibung', () {
      group('When parse aufgerufen wird', () {
        test('Then wird der ZÃ¤hler mit der Anzahl der Namen multipliziert',
            () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260115T190000Z
DTEND:20260115T210000Z
SUMMARY:Dienstabend
DESCRIPTION:Teilnehmende: Alex, Uwe, Sandy
END:VEVENT
BEGIN:VEVENT
DTSTART:20260212T190000Z
DTEND:20260212T210000Z
SUMMARY:Dienstabend
DESCRIPTION:Teilnehmende: Uwe, Sandy
END:VEVENT
BEGIN:VEVENT
DTSTART:20260312T190000Z
DTEND:20260312T210000Z
SUMMARY:Dienstabend
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // Event 1: 3 names, Event 2: 2 names, Event 3: no desc â†’ 1
          // Applied = 3 + 2 + 1 = 6
          expect(
            _getApplyValue(result, DienstabendRule.targetCategory),
            6,
          );

          // Display: targetCategory label with multiplied total = 6
          expect(
            _getDisplayValue(result, DienstabendRule.summaryMatch),
            6,
          );
        });
      });
    });

    group('Given San-Dienst-Termine ohne Beschreibung', () {
      group('When parse aufgerufen wird', () {
        test('Then wird je Ereignis ein Stundenwert von 1 gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260601T080000Z
DTEND:20260601T170000Z
SUMMARY:San-Dienst Klosterhofspiele
END:VEVENT
BEGIN:VEVENT
DTSTART:20260615T090000Z
DTEND:20260615T113000Z
SUMMARY:San-Dienst Post
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // Anzahl = 2 events
          expect(
            _getApplyValue(result, SanDienstRule.targetCategoryAnzahl),
            2,
          );
          // Stunden = 1 + 1 = 2 (no description â†’ count 1 per event)
          expect(
            _getApplyValue(result, SanDienstRule.targetCategoryStunden),
            2,
          );
        });
      });
    });

    group('Given San-Dienst-Termine mit Namen in der Beschreibung', () {
      group('When parse aufgerufen wird', () {
        test('Then werden Stunden als Ereignisse mal Namen berechnet', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260601T080000Z
DTEND:20260601T170000Z
SUMMARY:San-Dienst Post
DESCRIPTION:Teilnehmende: Uwe, Andi
END:VEVENT
BEGIN:VEVENT
DTSTART:20260615T080000Z
DTEND:20260615T170000Z
SUMMARY:San-Dienst
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // Anzahl = event count (not multiplied) = 2
          expect(
            _getApplyValue(result, SanDienstRule.targetCategoryAnzahl),
            2,
          );

          // Stunden = name-multiplied: 2 + 1 = 3
          expect(
            _getApplyValue(result, SanDienstRule.targetCategoryStunden),
            3,
          );
        });
      });
    });

    group('Given eine iCal-Datei mit allen drei Regeltypen', () {
      group('When parse aufgerufen wird', () {
        test('Then werden alle Regeln korrekt gezÃ¤hlt', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260420T150000Z
DTEND:20260420T160000Z
SUMMARY:Schwimmtraining
END:VEVENT
BEGIN:VEVENT
DTSTART:20260601T080000Z
DTEND:20260601T170000Z
SUMMARY:San-Dienst Klosterhofspiele
END:VEVENT
BEGIN:VEVENT
DTSTART:20260115T190000Z
DTEND:20260115T210000Z
SUMMARY:Dienstabend
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            1,
          );
          expect(
            _getApplyValue(result, SanDienstRule.targetCategoryAnzahl),
            1,
          );
          expect(
            _getApplyValue(result, SanDienstRule.targetCategoryStunden),
            1,
          );
          expect(
            _getApplyValue(result, DienstabendRule.targetCategory),
            1,
          );
        });
      });
    });

    group('Given iCal-Datei mit ähnlichen Dienstabend-Einträgen', () {
      group('When parse aufgerufen wird', () {
        test('Then wird "Dienstabend - Fürth" nicht als Dienstabend gezählt',
            () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260115T190000Z
DTEND:20260115T210000Z
SUMMARY:Dienstabend - Fürth
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, DienstabendRule.targetCategory),
            0,
          );
        });

        test('Then wird "Dienstabend (abgesagt)" nicht als Dienstabend gezählt',
            () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260115T190000Z
DTEND:20260115T210000Z
SUMMARY:Dienstabend (abgesagt)
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, DienstabendRule.targetCategory),
            0,
          );
        });

        test(
            'Then wird nur exakter "Dienstabend" gezählt, nicht ähnliche Einträge',
            () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260115T190000Z
DTEND:20260115T210000Z
SUMMARY:Dienstabend
END:VEVENT
BEGIN:VEVENT
DTSTART:20260122T190000Z
DTEND:20260122T210000Z
SUMMARY:Dienstabend - Fürth
END:VEVENT
BEGIN:VEVENT
DTSTART:20260129T190000Z
DTEND:20260129T210000Z
SUMMARY:Dienstabend (abgesagt)
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, DienstabendRule.targetCategory),
            1,
          );
        });
      });
    });

    group('Given iCal-Datei mit Rettungsschwimmausbildung-Terminen', () {
      group('When parse aufgerufen wird', () {
        test('Then werden Stunden × Teilnehmende berechnet', () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260310T180000Z
DTEND:20260310T200000Z
SUMMARY:Rettungsschwimmausbildung
DESCRIPTION:Teilnehmende: Max, Erika
END:VEVENT
BEGIN:VEVENT
DTSTART:20260317T180000Z
DTEND:20260317T200000Z
SUMMARY:Rettungsschwimmausbildung Kinder
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // Event 1: 2h × 2 = 4, Event 2: 2h × 1 = 2 → total 6
          expect(
            _getApplyValue(
                result, RettungsschwimmausbildungRule.targetCategory),
            6,
          );
        });

        test(
            'Then wird Rettungsschwimmausbildung separat in displayRows angezeigt',
            () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260310T180000Z
DTEND:20260310T200000Z
SUMMARY:Rettungsschwimmausbildung
DESCRIPTION:Teilnehmende: Max, Erika, Tom
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // 2h × 3 = 6
          expect(
            _getDisplayValue(
                result, RettungsschwimmausbildungRule.summaryPattern),
            6,
          );
        });

        test(
            'Then wird Rettungsschwimmausbildung getrennt von Dienstabend gezählt',
            () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260310T180000Z
DTEND:20260310T200000Z
SUMMARY:Rettungsschwimmausbildung
DESCRIPTION:Teilnehmende: Max, Erika
END:VEVENT
BEGIN:VEVENT
DTSTART:20260312T190000Z
DTEND:20260312T210000Z
SUMMARY:Dienstabend
DESCRIPTION:Teilnehmende: Uwe, Sandy, Tom
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          // Rettungsschwimm: 2h × 2 = 4
          expect(
            _getDisplayValue(
                result, RettungsschwimmausbildungRule.summaryPattern),
            4,
          );
          expect(
            _getDisplayValue(result, DienstabendRule.summaryMatch),
            3,
          );
        });
      });
    });

    group('Given iCal-Datei mit Whitespace in Summary', () {
      group('When parse aufgerufen wird', () {
        test(
            'Then wird Dienstabend mit führenden/nachfolgenden Leerzeichen erkannt',
            () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260115T190000Z
DTEND:20260115T210000Z
SUMMARY: Dienstabend 
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, DienstabendRule.targetCategory),
            1,
          );
        });

        test(
            'Then wird Schwimmtraining mit führenden/nachfolgenden Leerzeichen erkannt',
            () {
          const ical = '''
BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:20260420T150000Z
DTEND:20260420T160000Z
SUMMARY:  Schwimmtraining  
END:VEVENT
END:VCALENDAR''';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, SchwimmtrainingRule.targetCategoryAnzahl),
            1,
          );
        });
      });
    });

    group('Given eine iCal-Datei mit Öffentlichkeitsarbeit-Events in 2025', () {
      group('When parse für 2025 aufgerufen wird', () {
        test('Then werden beide Events korrekt gezählt', () {
          const ical =
              'BEGIN:VCALENDAR\r\nBEGIN:VEVENT\r\nDTSTART:20250118T130000Z\r\nDTEND:20250118T150000Z\r\nSUMMARY:SPD Neujahrsempfang (intern) (Öffentlichkeitsarbeit)\r\nEND:VEVENT\r\nBEGIN:VEVENT\r\nDTSTART:20250628T160000Z\r\nDTEND:20250628T180000Z\r\nSUMMARY:Festzug 125 Jahre FFW Keidenzell Stinzendorf (Öffentlichkeitsarbeit\r\n )\r\nEND:VEVENT\r\nEND:VCALENDAR';

          final result = sut.parse(ical, 2025);

          expect(
            _getApplyValue(result, OeffentlichkeitsarbeitRule.targetCategory),
            2,
          );
        });

        test('Then werden die Events für 2026 nicht gezählt', () {
          const ical =
              'BEGIN:VCALENDAR\r\nBEGIN:VEVENT\r\nDTSTART:20250118T130000Z\r\nDTEND:20250118T150000Z\r\nSUMMARY:SPD Neujahrsempfang (intern) (Öffentlichkeitsarbeit)\r\nEND:VEVENT\r\nEND:VCALENDAR';

          final result = sut.parse(ical, 2026);

          expect(
            _getApplyValue(result, OeffentlichkeitsarbeitRule.targetCategory),
            0,
          );
        });
      });
    });
  });
}
