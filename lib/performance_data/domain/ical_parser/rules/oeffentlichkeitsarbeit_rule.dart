import 'package:training_organizer/performance_data/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/mixins/teilnehmende_mixin.dart';

/// This rule should parse all "(Offentlichkeitsarbeit)" events from the ical file.
/// We use O instead of Ö because the parsing is not working correctly
class OeffentlichkeitsarbeitRule
    with TeilnehmendeMixin
    implements IcalParserRule {
  static const String summaryPattern = '(Offentlichkeitsarbeit)';
  static const String targetCategory = 'Öffentlichkeitsarbeit';

  @override
  bool matches(String summary) => summary.contains(summaryPattern);

  @override
  void processEvent({
    required DateTime startDateTime,
    DateTime? endDateTime,
    String? description,
    String? summary,
  }) {
    trackTeilnehmende(description);
  }

  @override
  void reset() => resetTeilnehmendeCount();

  @override
  List<IcalRuleDisplayRow> get displayRows => [
        IcalRuleDisplayRow(
          label: targetCategory,
          value: teilnehmendeCount,
        ),
      ];

  @override
  List<IcalRuleApplyEntry> get applyEntries => [
        IcalRuleApplyEntry(
          targetCategoryName: targetCategory,
          value: teilnehmendeCount,
          beschreibung: 'Öffentlichkeitsarbeit (iCal)',
        ),
      ];
}
