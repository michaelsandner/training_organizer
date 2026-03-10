import 'package:training_organizer/performance_data/domain/ical_parser/rules/ical_parser_rule.dart';

/// Result of an iCal import with display and apply data from all rules.
class IcalImportResult {
  final List<IcalRuleDisplayRow> displayRows;
  final List<IcalRuleApplyEntry> applyEntries;

  const IcalImportResult({
    required this.displayRows,
    required this.applyEntries,
  });
}
