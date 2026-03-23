import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';

/// Mixin for rules that count participants from the "Teilnehmende:" field.
/// Parses a numeric count (e.g. "Teilnehmende: 5").
mixin TeilnehmendeMixin {
  int _teilnehmendeCount = 0;

  int get teilnehmendeCount => _teilnehmendeCount;

  void trackTeilnehmende(String? description) {
    final count = parseTeilnehmendeCount(description);
    _teilnehmendeCount += count > 0 ? count : 1;
  }

  void resetTeilnehmendeCount() => _teilnehmendeCount = 0;
}
