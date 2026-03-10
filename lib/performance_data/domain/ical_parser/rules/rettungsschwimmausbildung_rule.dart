import 'package:training_organizer/performance_data/domain/ical_parser/rules/ical_parser_rule.dart';

/// This rule should parse all "Rettungsschwimmausbildung" events from the ical file
class RettungsschwimmausbildungRule implements IcalParserRule {
  static const String summaryPattern = 'Rettungsschwimmausbildung';
  static const String targetCategory = 'Ausbildung/Fortbildung';

  int _total = 0;

  int get total => _total;

  @override
  bool matches(String summary) => summary.contains(summaryPattern);

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
    _total += hours > 0 ? hours * count : count;
  }

  @override
  void reset() => _total = 0;

  @override
  List<IcalRuleDisplayRow> get displayRows => [
        IcalRuleDisplayRow(
          label: summaryPattern,
          value: _total,
        ),
      ];

  @override
  List<IcalRuleApplyEntry> get applyEntries => [
        IcalRuleApplyEntry(
          targetCategoryName: targetCategory,
          value: _total,
          beschreibung: 'Rettungsschwimmausbildung (iCal)',
        ),
      ];
}
