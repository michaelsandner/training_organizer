import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/event_count_mixin.dart';

/// This rule parses events with "tag:Gruppenstunde" in their description.
/// Anzahl = per-event positions (1 per event) with date.
/// Stunden = per-event positions with hours × participants.
class GruppenstundenRule with EventCountMixin implements IcalParserRule {
  static const String tagName = 'Gruppenstunde';
  static const String targetCategoryAnzahl =
      'Gruppenstunden/Jugendtraining (Anzahl)';
  static const String targetCategoryStunden =
      'Gruppenstunden/Jugendtraining (Stunden)';

  final List<IcalRuleApplyEntry> _perEventAnzahl = [];
  final List<IcalRuleApplyEntry> _perEventStunden = [];
  int _totalStunden = 0;

  int get totalStunden => _totalStunden;

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
    trackEventCount();
    final count = parseTeilnehmendeCount(description);
    final participants = count > 0 ? count : 1;
    int hours = 0;
    if (endDateTime != null) {
      final minutes = endDateTime.difference(startDateTime).inMinutes;
      hours = minutes > 0 ? (minutes / 60).ceil() : 0;
    }
    final stunden = hours * participants;
    _totalStunden += stunden;

    final label = summary?.trim() ?? '';
    final date = formatEventDate(startDateTime);
    final beschreibung =
        label.isNotEmpty ? '$label $date (iCal)' : '$date (iCal)';

    _perEventAnzahl.add(IcalRuleApplyEntry(
      targetCategoryName: targetCategoryAnzahl,
      value: 1,
      beschreibung: beschreibung,
      teilnehmende: count > 0 ? '$count' : '',
    ));

    _perEventStunden.add(IcalRuleApplyEntry(
      targetCategoryName: targetCategoryStunden,
      value: stunden,
      beschreibung: beschreibung,
      teilnehmende: count > 0 ? '$count' : '',
    ));
  }

  @override
  void reset() {
    resetEventCount();
    _perEventAnzahl.clear();
    _perEventStunden.clear();
    _totalStunden = 0;
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
          value: _totalStunden,
        ),
      ];

  @override
  List<IcalRuleApplyEntry> get applyEntries => [
        ..._perEventAnzahl,
        ..._perEventStunden,
      ];
}
