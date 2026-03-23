import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/event_time_mixin.dart';

/// This rule parses events with "tag:Schwimmtraining" in their description.
/// Anzahl = sum of teilnehmende counts, Stunden = total hours.
/// Single summarized position (no per-event breakdown).
class SchwimmtrainingRule with EventTimeMixin implements IcalParserRule {
  static const String tagName = 'Schwimmtraining';
  static const String targetCategoryAnzahl =
      'Gruppenstunden/Jugendtraining (Anzahl)';
  static const String targetCategoryStunden =
      'Gruppenstunden/Jugendtraining (Stunden)';

  int _teilnehmendeTotal = 0;

  int get teilnehmendeTotal => _teilnehmendeTotal;

  @override
  bool matches({required String summary, String? description}) =>
      matchesDescriptionTag(description, tagName);

  @override
  void processEvent({
    required DateTime startDateTime,
    DateTime? endDateTime,
    String? description,
    String? summary,
  }) {
    final count = parseTeilnehmendeCount(description);
    _teilnehmendeTotal += count > 0 ? count : 1;
    trackEventTime(startDateTime, endDateTime);
  }

  @override
  void reset() {
    _teilnehmendeTotal = 0;
    resetEventTime();
  }

  static const String displayLabelAnzahl = 'Jugendtraining (Anzahl)';
  static const String displayLabelStunden = 'Jugendtraining (Stunden)';

  @override
  List<IcalRuleDisplayRow> get displayRows => [
        IcalRuleDisplayRow(
          label: displayLabelAnzahl,
          value: _teilnehmendeTotal,
        ),
        IcalRuleDisplayRow(
          label: displayLabelStunden,
          value: totalHours,
        ),
      ];

  @override
  List<IcalRuleApplyEntry> get applyEntries => [
        IcalRuleApplyEntry(
          targetCategoryName: targetCategoryAnzahl,
          value: _teilnehmendeTotal,
          beschreibung: 'Jugendtraining (iCal)',
        ),
        IcalRuleApplyEntry(
          targetCategoryName: targetCategoryStunden,
          value: totalHours,
          beschreibung: 'Jugendtraining (iCal)',
        ),
      ];
}
