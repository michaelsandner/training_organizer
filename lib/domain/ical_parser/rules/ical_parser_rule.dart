/// Interface for iCal parser rules that match and count specific event types.
abstract class IcalParserRule {
  /// Returns true if this rule matches the event.
  /// Rules can match on [summary], [description], or both.
  bool matches({required String summary, String? description});

  /// Processes a single event occurrence.
  void processEvent({
    required DateTime startDateTime,
    DateTime? endDateTime,
    String? description,
    String? summary,
  });

  /// Resets all counters.
  void reset();

  /// Display rows for the confirmation dialog.
  List<IcalRuleDisplayRow> get displayRows;

  /// Entries to apply to performance data categories.
  List<IcalRuleApplyEntry> get applyEntries;
}

/// A single row shown in the import confirmation dialog.
class IcalRuleDisplayRow {
  final String label;
  final int value;

  const IcalRuleDisplayRow({required this.label, required this.value});
}

/// Describes a value to add to a specific performance data category.
class IcalRuleApplyEntry {
  final String targetCategoryName;
  final int value;
  final String beschreibung;
  final String teilnehmende;

  const IcalRuleApplyEntry({
    required this.targetCategoryName,
    required this.value,
    this.beschreibung = '',
    this.teilnehmende = '',
  });
}

/// Returns true if [description] contains "tag:{tagName}" (case-insensitive,
/// optional whitespace after the colon).
bool matchesDescriptionTag(String? description, String tagName) {
  if (description == null || description.trim().isEmpty) return false;
  final pattern = RegExp(
    r'tag:\s*' + RegExp.escape(tagName),
    caseSensitive: false,
  );
  return pattern.hasMatch(description);
}

/// Parses a numeric count from the "Teilnehmende:" field in a description.
/// Matches "Teilnehmende:{count}" where {count} is a number (e.g. 1, 2, 10).
/// Case-insensitive, optional whitespace after the colon.
/// Returns 0 if description is null or does not contain a valid marker.
int parseTeilnehmendeCount(String? description) {
  if (description == null || description.trim().isEmpty) return 0;
  final pattern = RegExp(
    r'teilnehmende:\s*(\d+)',
    caseSensitive: false,
  );
  final match = pattern.firstMatch(description);
  if (match == null) return 0;
  return int.tryParse(match.group(1)!) ?? 0;
}

/// Parses comma-separated names from the "Teilnehmende:" field in a description.
/// Returns 0 if description is null or does not contain the marker.
int parseNameCount(String? description) {
  if (description == null || description.trim().isEmpty) return 0;
  const marker = 'Teilnehmende:';
  final index = description.indexOf(marker);
  if (index == -1) return 0;
  final afterMarker = description.substring(index + marker.length);
  // Take only the text until the next newline (if any)
  final newlineIndex = afterMarker.indexOf('\n');
  final namesSection =
      newlineIndex >= 0 ? afterMarker.substring(0, newlineIndex) : afterMarker;
  return namesSection
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .length;
}

/// Formats a date as DD.MM.YYYY for display in position descriptions.
String formatEventDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}
