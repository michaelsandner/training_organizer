import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/event_count_mixin.dart';

/// This rule parses events with "tag:Schwimmtraining" in their description.
/// Anzahl = number of events, Stunden = total hours × participants (summarized).
class SchwimmtrainingRule with EventCountMixin implements IcalParserRule {
  static const String tagName = 'Schwimmtraining';
  static const String targetCategoryAnzahl =
      'Gruppenstunden/Jugendtraining (Anzahl)';
  static const String targetCategoryStunden =
      'Gruppenstunden/Jugendtraining (Stunden)';

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
    _totalStunden += hours * participants;
  }

  @override
  void reset() {
    resetEventCount();
    _totalStunden = 0;
  }

  static const String displayLabelAnzahl = 'Jugendtraining (Anzahl)';
  static const String displayLabelStunden = 'Jugendtraining (Stunden)';

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
        IcalRuleApplyEntry(
          targetCategoryName: targetCategoryAnzahl,
          value: eventCount,
          beschreibung: 'Jugendtraining (iCal)',
        ),
        IcalRuleApplyEntry(
          targetCategoryName: targetCategoryStunden,
          value: _totalStunden,
          beschreibung: 'Jugendtraining (iCal)',
        ),
      ];
}
