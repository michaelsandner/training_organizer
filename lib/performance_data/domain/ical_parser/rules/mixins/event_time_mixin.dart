/// Mixin for rules that need to track total hours from event durations.
mixin EventTimeMixin {
  int _totalHours = 0;

  int get totalHours => _totalHours;

  void trackEventTime(DateTime startDateTime, DateTime? endDateTime) {
    if (endDateTime != null) {
      final minutes = endDateTime.difference(startDateTime).inMinutes;
      _totalHours += minutes > 0 ? (minutes / 60).ceil() : 0;
    }
  }

  void resetEventTime() => _totalHours = 0;
}
