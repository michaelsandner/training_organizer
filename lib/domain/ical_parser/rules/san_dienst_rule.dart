import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/event_count_mixin.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/per_event_position_mixin.dart';

/// This rule parses events with "tag:Sandienst" in their description.
/// Anzahl counts events, Stunden multiplies hours × teilnehmende count.
class SanDienstRule
    with EventCountMixin, PerEventPositionMixin
    implements IcalParserRule {
  static const String tagName = 'Sandienst';
  static const String targetCategoryAnzahl =
      'ohne Wachdienste an Wachstationen (Anzahl)';
  static const String targetCategoryStunden =
      'ohne Wachdienste an Wachstationen (Stunden)';

  int _totalStunden = 0;
  final List<IcalRuleApplyEntry> _perEventStunden = [];

  int get totalStunden => _totalStunden;

  @override
  String get targetCategoryName => targetCategoryAnzahl;

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
    final stunden = hours > 0 ? hours * participants : participants;
    _totalStunden += stunden;

    final label = summary?.trim() ?? '';
    final date = formatEventDate(startDateTime);
    final beschreibung =
        label.isNotEmpty ? '$label $date (iCal)' : '$date (iCal)';

    addPerEventEntry(IcalRuleApplyEntry(
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
    resetPerEventEntries();
    _perEventStunden.clear();
    _totalStunden = 0;
  }

  @override
  List<IcalRuleDisplayRow> get displayRows => [
        IcalRuleDisplayRow(
          label: targetCategoryAnzahl,
          value: eventCount,
        ),
        IcalRuleDisplayRow(
          label: targetCategoryStunden,
          value: _totalStunden,
        ),
      ];

  @override
  List<IcalRuleApplyEntry> get applyEntries => [
        ...super.applyEntries,
        ..._perEventStunden,
      ];
}
