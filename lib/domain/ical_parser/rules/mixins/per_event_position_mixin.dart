import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';

/// Mixin for rules that create a separate position for each parsed event.
mixin PerEventPositionMixin {
  final List<IcalRuleApplyEntry> _perEventEntries = [];
  int _perEventTotal = 0;

  String get targetCategoryName;

  int get perEventTotal => _perEventTotal;

  void addPerEventEntry(IcalRuleApplyEntry entry) {
    _perEventTotal += entry.value;
    _perEventEntries.add(entry);
  }

  void resetPerEventEntries() {
    _perEventEntries.clear();
    _perEventTotal = 0;
  }

  List<IcalRuleDisplayRow> get displayRows => [
        IcalRuleDisplayRow(
          label: targetCategoryName,
          value: _perEventTotal,
        ),
      ];

  List<IcalRuleApplyEntry> get applyEntries =>
      List.unmodifiable(_perEventEntries);
}
