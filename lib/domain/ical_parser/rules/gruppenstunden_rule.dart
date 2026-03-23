import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/event_time_mixin.dart';

/// This rule parses events with "tag:Gruppenstunde" in their description.
/// Anzahl = per-event positions with teilnehmende count and date.
/// Stunden = total hours (single entry).
class GruppenstundenRule with EventTimeMixin implements IcalParserRule {
  static const String tagName = 'Gruppenstunde';
  static const String targetCategoryAnzahl =
      'Gruppenstunden/Jugendtraining (Anzahl)';
  static const String targetCategoryStunden =
      'Gruppenstunden/Jugendtraining (Stunden)';

  final List<IcalRuleApplyEntry> _perEventAnzahl = [];
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
    final participants = count > 0 ? count : 1;
    _teilnehmendeTotal += participants;
    trackEventTime(startDateTime, endDateTime);

    final label = summary?.trim() ?? '';
    final date = formatEventDate(startDateTime);
    _perEventAnzahl.add(IcalRuleApplyEntry(
      targetCategoryName: targetCategoryAnzahl,
      value: participants,
      beschreibung:
          label.isNotEmpty ? '$label $date (iCal)' : '$date (iCal)',
      teilnehmende: count > 0 ? '$count' : '',
    ));
  }

  @override
  void reset() {
    _perEventAnzahl.clear();
    _teilnehmendeTotal = 0;
    resetEventTime();
  }

  static const String displayLabelAnzahl = 'Gruppenstunden (Anzahl)';
  static const String displayLabelStunden = 'Gruppenstunden (Stunden)';

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
        ..._perEventAnzahl,
        IcalRuleApplyEntry(
          targetCategoryName: targetCategoryStunden,
          value: totalHours,
          beschreibung: 'Gruppenstunden (iCal)',
        ),
      ];
}
