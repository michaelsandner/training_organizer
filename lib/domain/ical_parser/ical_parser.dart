import 'package:training_organizer/domain/ical_parser/ical_date_parser.dart';
import 'package:training_organizer/domain/ical_parser/ical_import_result.dart';
import 'package:training_organizer/domain/ical_parser/rules/dienstabend_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/fortbildung_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/gremienarbeit_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/gruppenstunden_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/naturschutz_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/oeffentlichkeitsarbeit_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/rettungsschwimmausbildung_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/san_dienst_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/schwimmtraining_rule.dart';

/// Internal model for a parsed VEVENT.
class _IcalEvent {
  final String? summary;
  final String? dtStart;
  final String? dtEnd;
  final String? description;
  final String? uid;
  final String? rrule;
  final String? recurrenceId;
  final List<String> exDates;

  const _IcalEvent({
    this.summary,
    this.dtStart,
    this.dtEnd,
    this.description,
    this.uid,
    this.rrule,
    this.recurrenceId,
    this.exDates = const [],
  });
}

/// A resolved single occurrence of an event for a specific date.
class _ResolvedEvent {
  final String summary;
  final DateTime startDateTime;
  final DateTime? endDateTime;
  final String? description;

  const _ResolvedEvent({
    required this.summary,
    required this.startDateTime,
    this.endDateTime,
    this.description,
  });
}

/// Parses an iCal file and counts specific events for a selected year.
class IcalParser {
  final IcalDateParser _dateParser = IcalDateParser();

  static List<IcalParserRule> get defaultRules => [
        SchwimmtrainingRule(),
        GruppenstundenRule(),
        DienstabendRule(),
        RettungsschwimmausbildungRule(),
        FortbildungRule(),
        NaturschutzRule(),
        SanDienstRule(),
        OeffentlichkeitsarbeitRule(),
        GremienarbeitRule(),
      ];

  /// Parses [icalContent], resolves all events for [year], and applies [rules].
  IcalImportResult parse(
    String icalContent,
    int year, {
    List<IcalParserRule>? rules,
  }) {
    final activeRules = rules ?? defaultRules;
    for (final rule in activeRules) {
      rule.reset();
    }

    final events = _extractEvents(icalContent);
    final resolved = _resolveEvents(events, year);

    for (final event in resolved) {
      for (final rule in activeRules) {
        if (rule.matches(event.summary)) {
          rule.processEvent(
            startDateTime: event.startDateTime,
            endDateTime: event.endDateTime,
            description: event.description,
            summary: event.summary,
          );
        }
      }
    }

    return IcalImportResult(
      displayRows: activeRules.expand((r) => r.displayRows).toList(),
      applyEntries: activeRules.expand((r) => r.applyEntries).toList(),
    );
  }

  /// Resolves all events into individual occurrences for the given [year].
  List<_ResolvedEvent> _resolveEvents(List<_IcalEvent> events, int year) {
    final seriesEvents = <_IcalEvent>[];
    final overrideEvents = <_IcalEvent>[];
    final standaloneEvents = <_IcalEvent>[];

    for (final event in events) {
      if (event.recurrenceId != null) {
        overrideEvents.add(event);
      } else if (event.rrule != null) {
        seriesEvents.add(event);
      } else {
        standaloneEvents.add(event);
      }
    }

    // Index overrides by UID and normalized date
    final overridesByUid = <String, Map<String, _IcalEvent>>{};
    for (final override in overrideEvents) {
      if (override.uid == null || override.recurrenceId == null) continue;
      overridesByUid.putIfAbsent(override.uid!, () => {})[
          _dateParser.normalizeDate(override.recurrenceId!)] = override;
    }

    final seriesUids = <String>{};
    final resolved = <_ResolvedEvent>[];

    // Resolve standalone events
    for (final event in standaloneEvents) {
      if (event.summary == null || event.dtStart == null) continue;
      final eventYear = _dateParser.parseYear(event.dtStart!);
      if (eventYear != year) continue;

      resolved.add(_ResolvedEvent(
        summary: event.summary!.trim(),
        startDateTime:
            _dateParser.parseDateTime(event.dtStart!) ?? DateTime(year),
        endDateTime: event.dtEnd != null
            ? _dateParser.parseDateTime(event.dtEnd!)
            : null,
        description: event.description,
      ));
    }

    // Resolve recurring series
    for (final series in seriesEvents) {
      if (series.summary == null || series.dtStart == null) continue;
      if (series.uid != null) seriesUids.add(series.uid!);

      final startDt = _dateParser.parseDateTime(series.dtStart!);
      if (startDt == null) continue;

      final endDt = series.dtEnd != null
          ? _dateParser.parseDateTime(series.dtEnd!)
          : null;
      final duration = endDt?.difference(startDt);

      final dates = _expandRrule(
        DateTime(startDt.year, startDt.month, startDt.day),
        series.rrule!,
        year,
      );
      final exDateSet = series.exDates.map(_dateParser.normalizeDate).toSet();
      final uid = series.uid ?? '';
      final uidOverrides = overridesByUid[uid] ?? {};

      for (final date in dates) {
        final dateKey = _dateParser.dateToKey(date);

        // Skip excluded dates
        if (exDateSet.contains(dateKey)) continue;

        // Apply override if present
        if (uidOverrides.containsKey(dateKey)) {
          final override = uidOverrides[dateKey]!;
          final overrideStart = override.dtStart != null
              ? _dateParser.parseDateTime(override.dtStart!)
              : null;
          final overrideEnd = override.dtEnd != null
              ? _dateParser.parseDateTime(override.dtEnd!)
              : null;

          final occurrenceStart = overrideStart ??
              DateTime(date.year, date.month, date.day, startDt.hour,
                  startDt.minute);
          final occurrenceEnd = overrideEnd ??
              (duration != null ? occurrenceStart.add(duration) : null);

          resolved.add(_ResolvedEvent(
            summary: (override.summary ?? series.summary!).trim(),
            startDateTime: occurrenceStart,
            endDateTime: occurrenceEnd,
            description: override.description ?? series.description,
          ));
          continue;
        }

        // Regular occurrence: apply series time to the expanded date
        final occurrenceStart = DateTime(
          date.year,
          date.month,
          date.day,
          startDt.hour,
          startDt.minute,
          startDt.second,
        );
        resolved.add(_ResolvedEvent(
          summary: series.summary!.trim(),
          startDateTime: occurrenceStart,
          endDateTime: duration != null ? occurrenceStart.add(duration) : null,
          description: series.description,
        ));
      }
    }

    // Resolve orphan overrides (no corresponding series in this file)
    for (final override in overrideEvents) {
      if (override.summary == null || override.recurrenceId == null) continue;
      final uid = override.uid ?? '';
      if (seriesUids.contains(uid)) continue;

      final eventYear = _dateParser.parseYear(override.recurrenceId!);
      if (eventYear != year) continue;

      resolved.add(_ResolvedEvent(
        summary: override.summary!.trim(),
        startDateTime: override.dtStart != null
            ? (_dateParser.parseDateTime(override.dtStart!) ?? DateTime(year))
            : DateTime(year),
        endDateTime: override.dtEnd != null
            ? _dateParser.parseDateTime(override.dtEnd!)
            : null,
        description: override.description,
      ));
    }

    return resolved;
  }

  /// Expands an RRULE series and returns all dates that fall within [year].
  List<DateTime> _expandRrule(DateTime startDate, String rrule, int year) {
    final params = _parseRruleParams(rrule);
    final freq = params['FREQ'];
    if (freq == 'MONTHLY') return _expandMonthly(startDate, params, year);
    if (freq != 'WEEKLY') return _expandNonWeekly(startDate, rrule, year);

    final interval = int.tryParse(params['INTERVAL'] ?? '1') ?? 1;
    final until = params['UNTIL'] != null
        ? _dateParser.parseDate(params['UNTIL']!)
        : null;
    final count = int.tryParse(params['COUNT'] ?? '') ?? -1;

    final yearStart = DateTime(year);
    final yearEnd = DateTime(year + 1);

    final dates = <DateTime>[];
    var current = startDate;
    var generated = 0;

    while (true) {
      if (until != null && current.isAfter(until)) break;
      if (count > 0 && generated >= count) break;
      if (current.year > year) break;

      if (!current.isBefore(yearStart) && current.isBefore(yearEnd)) {
        dates.add(current);
      }

      current = current.add(Duration(days: 7 * interval));
      generated++;
    }

    return dates;
  }

  /// Expands a MONTHLY RRULE with optional BYDAY (e.g. "1SA" = 1st Saturday).
  List<DateTime> _expandMonthly(
      DateTime startDate, Map<String, String> params, int year) {
    final interval = int.tryParse(params['INTERVAL'] ?? '1') ?? 1;
    final until = params['UNTIL'] != null
        ? _dateParser.parseDate(params['UNTIL']!)
        : null;
    final count = int.tryParse(params['COUNT'] ?? '') ?? -1;
    final byDay = params['BYDAY'];

    final yearStart = DateTime(year);
    final yearEnd = DateTime(year + 1);
    final dates = <DateTime>[];

    var currentYear = startDate.year;
    var currentMonth = startDate.month;
    var generated = 0;

    while (true) {
      final date = byDay != null
          ? _resolveByDay(currentYear, currentMonth, byDay, startDate)
          : DateTime(currentYear, currentMonth, startDate.day, startDate.hour,
              startDate.minute, startDate.second);

      if (date != null) {
        if (until != null && date.isAfter(until)) break;
        if (count > 0 && generated >= count) break;
        if (date.year > year) break;

        if (!date.isBefore(startDate) &&
            !date.isBefore(yearStart) &&
            date.isBefore(yearEnd)) {
          dates.add(date);
        }
        generated++;
      }

      currentMonth += interval;
      while (currentMonth > 12) {
        currentMonth -= 12;
        currentYear++;
      }
      if (currentYear > year) break;
    }

    return dates;
  }

  /// Resolves a BYDAY value like "1SA" (1st Saturday) to an actual date.
  DateTime? _resolveByDay(
      int year, int month, String byDay, DateTime startDate) {
    const dayMap = {
      'MO': DateTime.monday,
      'TU': DateTime.tuesday,
      'WE': DateTime.wednesday,
      'TH': DateTime.thursday,
      'FR': DateTime.friday,
      'SA': DateTime.saturday,
      'SU': DateTime.sunday,
    };

    final match = RegExp(r'^(-?\d+)([A-Z]{2})$').firstMatch(byDay);
    if (match == null) return null;

    final nth = int.parse(match.group(1)!);
    final weekday = dayMap[match.group(2)!];
    if (weekday == null) return null;

    if (nth > 0) {
      // Nth weekday from start of month
      var date = DateTime(year, month, 1);
      while (date.weekday != weekday) {
        date = date.add(const Duration(days: 1));
      }
      date = date.add(Duration(days: 7 * (nth - 1)));
      if (date.month != month) return null;
      return DateTime(date.year, date.month, date.day, startDate.hour,
          startDate.minute, startDate.second);
    } else if (nth < 0) {
      // Nth weekday from end of month
      final lastDay = DateTime(year, month + 1, 0);
      var date = lastDay;
      while (date.weekday != weekday) {
        date = date.subtract(const Duration(days: 1));
      }
      date = date.subtract(Duration(days: 7 * (-nth - 1)));
      if (date.month != month) return null;
      return DateTime(date.year, date.month, date.day, startDate.hour,
          startDate.minute, startDate.second);
    }

    return null;
  }

  /// Fallback for non-weekly series (MONTHLY, YEARLY etc.)
  /// Only counts the DTSTART if it falls within the year.
  List<DateTime> _expandNonWeekly(DateTime startDate, String rrule, int year) {
    if (startDate.year == year) return [startDate];
    return [];
  }

  Map<String, String> _parseRruleParams(String rrule) {
    final params = <String, String>{};
    for (final part in rrule.split(';')) {
      final eq = part.indexOf('=');
      if (eq == -1) continue;
      params[part.substring(0, eq)] = part.substring(eq + 1);
    }
    return params;
  }

  List<_IcalEvent> _extractEvents(String content) {
    final events = <_IcalEvent>[];
    final lines = content
        .replaceAll('\r\n ', '')
        .replaceAll('\r\n\t', '')
        .split(RegExp(r'\r?\n'));

    Map<String, String>? currentProps;
    List<String>? currentExDates;

    for (final line in lines) {
      if (line.startsWith('BEGIN:VEVENT')) {
        currentProps = {};
        currentExDates = [];
      } else if (line.startsWith('END:VEVENT')) {
        if (currentProps != null) {
          events.add(_IcalEvent(
            summary: currentProps['SUMMARY'],
            dtStart: currentProps['DTSTART'],
            dtEnd: currentProps['DTEND'],
            description: currentProps['DESCRIPTION'],
            uid: currentProps['UID'],
            rrule: currentProps['RRULE'],
            recurrenceId: currentProps['RECURRENCE-ID'],
            exDates: currentExDates ?? [],
          ));
        }
        currentProps = null;
        currentExDates = null;
      } else if (currentProps != null) {
        final colonIndex = line.indexOf(':');
        if (colonIndex == -1) continue;
        final keyPart = line.substring(0, colonIndex);
        final value = line.substring(colonIndex + 1).trim();
        final propertyName = keyPart.contains(';')
            ? keyPart.substring(0, keyPart.indexOf(';')).trim()
            : keyPart.trim();

        // Unescape iCal property values
        final unescapedValue = value
            .replaceAll('\\n', '\n')
            .replaceAll('\\N', '\n')
            .replaceAll('\\,', ',')
            .replaceAll('\\\\', '\\');

        if (propertyName == 'EXDATE') {
          // EXDATE can contain multiple comma-separated dates
          currentExDates!.addAll(value.split(',').map((e) => e.trim()));
        } else {
          currentProps.putIfAbsent(propertyName, () => unescapedValue);
        }
      }
    }

    return events;
  }
}
