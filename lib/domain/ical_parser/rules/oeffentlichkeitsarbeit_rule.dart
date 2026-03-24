import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/per_event_position_mixin.dart';

/// This rule parses events with "tag:Öffentlichkeitsarbeit" in their description.
class OeffentlichkeitsarbeitRule
    with PerEventPositionMixin
    implements IcalParserRule {
  static const String tagName = 'Öffentlichkeitsarbeit';
  static const String targetCategory = 'Öffentlichkeitsarbeit';

  @override
  String get targetCategoryName => targetCategory;

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
    int hours = 0;
    if (endDateTime != null) {
      final minutes = endDateTime.difference(startDateTime).inMinutes;
      hours = minutes > 0 ? (minutes / 60).ceil() : 0;
    }
    final value = hours > 0 ? hours * participants : participants;
    final label = summary?.trim() ?? '';
    final date = formatEventDate(startDateTime);
    addPerEventEntry(IcalRuleApplyEntry(
      targetCategoryName: targetCategory,
      value: value,
      beschreibung: label.isNotEmpty ? '$label $date (iCal)' : '$date (iCal)',
      teilnehmende: count > 0 ? '$count' : '',
    ));
  }

  @override
  void reset() => resetPerEventEntries();
}
