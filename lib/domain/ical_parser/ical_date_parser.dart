/// Utility class for parsing iCal date and datetime strings.
class IcalDateParser {
  DateTime? parseDateTime(String value) {
    final cleaned = value.replaceAll('Z', '');
    if (cleaned.length >= 15) {
      final y = int.tryParse(cleaned.substring(0, 4));
      final mo = int.tryParse(cleaned.substring(4, 6));
      final d = int.tryParse(cleaned.substring(6, 8));
      final h = int.tryParse(cleaned.substring(9, 11));
      final mi = int.tryParse(cleaned.substring(11, 13));
      final s = int.tryParse(cleaned.substring(13, 15));
      if (y != null && mo != null && d != null && h != null && mi != null) {
        return DateTime(y, mo, d, h, mi, s ?? 0);
      }
    }
    return parseDate(cleaned);
  }

  DateTime? parseDate(String dtStart) {
    final dateStr = dtStart.replaceAll('Z', '');
    if (dateStr.length >= 8) {
      final y = int.tryParse(dateStr.substring(0, 4));
      final m = int.tryParse(dateStr.substring(4, 6));
      final d = int.tryParse(dateStr.substring(6, 8));
      if (y != null && m != null && d != null) {
        return DateTime(y, m, d);
      }
    }
    return null;
  }

  int? parseYear(String dtStart) {
    final dateStr = dtStart.replaceAll('Z', '');
    if (dateStr.length >= 8) {
      return int.tryParse(dateStr.substring(0, 4));
    }
    return null;
  }

  /// Normalizes a date to YYYYMMDD format for comparisons.
  String normalizeDate(String dateValue) {
    final cleaned = dateValue.replaceAll('Z', '').trim();
    if (cleaned.length >= 8) return cleaned.substring(0, 8);
    return cleaned;
  }

  String dateToKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y$m$d';
  }
}
