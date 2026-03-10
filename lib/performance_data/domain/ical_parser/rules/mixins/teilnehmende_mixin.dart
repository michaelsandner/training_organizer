import 'package:training_organizer/performance_data/domain/ical_parser/rules/ical_parser_rule.dart';

/// Mixin for rules that count participants from the "Teilnehmende:" field.
mixin TeilnehmendeMixin {
  int _teilnehmendeCount = 0;

  int get teilnehmendeCount => _teilnehmendeCount;

  void trackTeilnehmende(String? description) {
    final names = parseNameCount(description);
    _teilnehmendeCount += names > 0 ? names : 1;
  }

  void resetTeilnehmendeCount() => _teilnehmendeCount = 0;
}
