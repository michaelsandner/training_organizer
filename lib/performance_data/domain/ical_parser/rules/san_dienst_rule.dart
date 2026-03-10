import 'package:training_organizer/performance_data/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/mixins/event_count_mixin.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/mixins/teilnehmende_mixin.dart';

/// This rule should parse all "San-Dienst" events from the ical file
class SanDienstRule
    with EventCountMixin, TeilnehmendeMixin
    implements IcalParserRule {
  static const String summaryPattern = 'San-Dienst';
  static const String targetCategoryAnzahl =
      'ohne Wachdienste an Wachstationen (Anzahl)';
  static const String targetCategoryStunden =
      'ohne Wachdienste an Wachstationen (Stunden)';

  @override
  bool matches(String summary) => summary.contains(summaryPattern);

  @override
  void processEvent({
    required DateTime startDateTime,
    DateTime? endDateTime,
    String? description,
    String? summary,
  }) {
    trackEventCount();
    trackTeilnehmende(description);
  }

  @override
  void reset() {
    resetEventCount();
    resetTeilnehmendeCount();
  }

  @override
  List<IcalRuleDisplayRow> get displayRows => [
        IcalRuleDisplayRow(
          label: targetCategoryAnzahl,
          value: eventCount,
        ),
        IcalRuleDisplayRow(
          label: targetCategoryStunden,
          value: teilnehmendeCount,
        ),
      ];

  @override
  List<IcalRuleApplyEntry> get applyEntries => [
        IcalRuleApplyEntry(
          targetCategoryName: targetCategoryAnzahl,
          value: eventCount,
          beschreibung: 'San-Dienst (iCal)',
        ),
        IcalRuleApplyEntry(
          targetCategoryName: targetCategoryStunden,
          value: teilnehmendeCount,
          beschreibung: 'San-Dienst (iCal)',
        ),
      ];
}
