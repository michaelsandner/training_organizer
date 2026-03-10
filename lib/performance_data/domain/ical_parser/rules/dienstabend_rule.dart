import 'package:training_organizer/performance_data/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/mixins/per_event_position_mixin.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/rules/mixins/teilnehmende_mixin.dart';

/// This rule should parse all "Dienstabend" events from the ical file
class DienstabendRule
    with TeilnehmendeMixin, PerEventPositionMixin
    implements IcalParserRule {
  static const String summaryMatch = 'Dienstabend';
  static const String targetCategory = 'Ausbildung/Fortbildung';

  static const List<String> _monthNames = [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];

  @override
  String get targetCategoryName => targetCategory;

  @override
  bool matches(String summary) => summary.trim() == summaryMatch;

  @override
  void processEvent({
    required DateTime startDateTime,
    DateTime? endDateTime,
    String? description,
    String? summary,
  }) {
    final count = parseNameCount(description);
    final month = _monthNames[startDateTime.month - 1];
    addPerEventEntry(IcalRuleApplyEntry(
      targetCategoryName: targetCategoryName,
      value: count > 0 ? count : 1,
      beschreibung: 'Dienstabend $month (iCal)',
      teilnehmende: count > 0 ? '$count' : '',
    ));
  }

  @override
  List<IcalRuleDisplayRow> get displayRows => [
        IcalRuleDisplayRow(
          label: summaryMatch,
          value: perEventTotal,
        ),
      ];

  @override
  void reset() {
    resetTeilnehmendeCount();
    resetPerEventEntries();
  }
}
