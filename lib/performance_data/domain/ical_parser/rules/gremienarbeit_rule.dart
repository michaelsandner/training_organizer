import 'package:training_organizer/performance_data/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/mixins/per_event_position_mixin.dart';

/// This rule should parse all "Gremienarbeit" events from the ical file
class GremienarbeitRule with PerEventPositionMixin implements IcalParserRule {
  static const String summaryPattern = '(Gremienarbeit)';

  @override
  String get targetCategoryName => 'Gremienarbeit';

  @override
  bool matches(String summary) => summary.contains(summaryPattern);

  @override
  void processEvent({
    required DateTime startDateTime,
    DateTime? endDateTime,
    String? description,
    String? summary,
  }) {
    int hours = 0;
    if (endDateTime != null) {
      final minutes = endDateTime.difference(startDateTime).inMinutes;
      hours = minutes > 0 ? (minutes / 60).ceil() : 0;
    }
    final label = summary?.trim() ?? '';
    addPerEventEntry(IcalRuleApplyEntry(
      targetCategoryName: targetCategoryName,
      value: hours,
      beschreibung: label.isNotEmpty ? '$label (iCal)' : '(iCal)',
    ));
  }

  @override
  void reset() => resetPerEventEntries();
}
