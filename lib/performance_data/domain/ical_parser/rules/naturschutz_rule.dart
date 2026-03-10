import 'package:training_organizer/performance_data/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/mixins/per_event_position_mixin.dart';

/// This rule should parse all "(Naturschutz)" events from the ical file
class NaturschutzRule with PerEventPositionMixin implements IcalParserRule {
  static const String summaryPattern = '(Naturschutz)';

  @override
  String get targetCategoryName => 'Naturschutz';

  @override
  bool matches(String summary) => summary.contains(summaryPattern);

  @override
  void processEvent({
    required DateTime startDateTime,
    DateTime? endDateTime,
    String? description,
    String? summary,
  }) {
    final names = parseNameCount(description);
    final count = names > 0 ? names : 1;
    final label = summary?.trim() ?? '';
    addPerEventEntry(IcalRuleApplyEntry(
      targetCategoryName: targetCategoryName,
      value: count,
      beschreibung: label.isNotEmpty ? '$label (iCal)' : '(iCal)',
      teilnehmende: names > 0 ? '$names' : '',
    ));
  }

  @override
  void reset() => resetPerEventEntries();
}
