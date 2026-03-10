/// Mixin for rules that need to count the number of matched events.
mixin EventCountMixin {
  int _eventCount = 0;

  int get eventCount => _eventCount;

  void trackEventCount() => _eventCount++;

  void resetEventCount() => _eventCount = 0;
}
