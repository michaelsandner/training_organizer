import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/event_count_mixin.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/event_time_mixin.dart';

/// This rule should parse all "Gruppenstunden" events from the ical file
class GruppenstundenRule
    with EventCountMixin, EventTimeMixin
    implements IcalParserRule {
  static const List<String> validSummaries = [
    'Gruppenstunde',
    'Gruppenstunde - Jugend',
    'Gruppenstunde - Jugend (intern)',
  ];
  static const String targetCategoryAnzahl =
      'Gruppenstunden/Jugendtraining (Anzahl)';
  static const String targetCategoryStunden =
      'Gruppenstunden/Jugendtraining (Stunden)';

  @override
  bool matches(String summary) => validSummaries.contains(summary.trim());

  @override
  void processEvent({
    required DateTime startDateTime,
    DateTime? endDateTime,
    String? description,
    String? summary,
  }) {
    trackEventCount();
    trackEventTime(startDateTime, endDateTime);
  }

  @override
  void reset() {
    resetEventCount();
    resetEventTime();
  }

  static const String displayLabelAnzahl = 'Gruppenstunden (Anzahl)';
  static const String displayLabelStunden = 'Gruppenstunden (Stunden)';

  @override
  List<IcalRuleDisplayRow> get displayRows => [
        IcalRuleDisplayRow(
          label: displayLabelAnzahl,
          value: eventCount,
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
          value: eventCount,
          beschreibung: 'Gruppenstunden (iCal)',
        ),
        IcalRuleApplyEntry(
          targetCategoryName: targetCategoryStunden,
          value: totalHours,
          beschreibung: 'Gruppenstunden (iCal)',
        ),
      ];
}
