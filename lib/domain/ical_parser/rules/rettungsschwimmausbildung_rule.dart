import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/per_event_position_mixin.dart';

/// This rule should parse all "Rettungsschwimmausbildung" events from the ical file.
/// Creates a separate position per event with date in the description.
class RettungsschwimmausbildungRule
    with PerEventPositionMixin
    implements IcalParserRule {
  static const String summaryPattern = 'Rettungsschwimmausbildung';
  static const String targetCategory = 'Ausbildung/Fortbildung';

  @override
  String get targetCategoryName => targetCategory;

  @override
  bool matches({required String summary, String? description}) =>
      summary.contains(summaryPattern);

  @override
  void processEvent({
    required DateTime startDateTime,
    DateTime? endDateTime,
    String? description,
    String? summary,
  }) {
    final teilnehmende = parseNameCount(description);
    final count = teilnehmende > 0 ? teilnehmende : 1;
    int hours = 0;
    if (endDateTime != null) {
      final minutes = endDateTime.difference(startDateTime).inMinutes;
      hours = minutes > 0 ? (minutes / 60).ceil() : 0;
    }
    final value = hours > 0 ? hours * count : count;
    final label = summary?.trim() ?? '';
    final date = formatEventDate(startDateTime);
    addPerEventEntry(IcalRuleApplyEntry(
      targetCategoryName: targetCategory,
      value: value,
      beschreibung: label.isNotEmpty ? '$label $date (iCal)' : '$date (iCal)',
      teilnehmende: teilnehmende > 0 ? '$teilnehmende' : '',
    ));
  }

  @override
  List<IcalRuleDisplayRow> get displayRows => [
        IcalRuleDisplayRow(
          label: summaryPattern,
          value: perEventTotal,
        ),
      ];

  @override
  void reset() => resetPerEventEntries();
}
