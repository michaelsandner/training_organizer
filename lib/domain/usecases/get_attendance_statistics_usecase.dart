import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';

class GroupAttendanceData {
  final Group group;
  final Map<DateTime, int> counts;

  const GroupAttendanceData({
    required this.group,
    required this.counts,
  });
}

class AttendanceSectionData {
  final List<DateTime> dates;
  final List<GroupAttendanceData> groupData;
  final Map<DateTime, int> sums;

  const AttendanceSectionData({
    required this.dates,
    required this.groupData,
    required this.sums,
  });
}

class GetAttendanceStatisticsUseCase {
  static const List<Group> saturdayGroups = [
    Group.group1,
    Group.group2,
    Group.group4,
    Group.group5,
  ];

  static const List<Group> wednesdayGroups = [
    Group.wednesday,
    Group.active,
  ];

  AttendanceSectionData execute(
    List<Trainee> trainees,
    List<Group> groups,
    int weekday,
  ) {
    final dates = _collectDates(trainees, groups, weekday);
    final groupData = _computeGroupCounts(trainees, groups, dates);
    final sums = _computeSums(groupData, dates);

    return AttendanceSectionData(
      dates: dates,
      groupData: groupData,
      sums: sums,
    );
  }

  List<DateTime> _collectDates(
    List<Trainee> trainees,
    List<Group> groups,
    int weekday,
  ) {
    final dateSet = <DateTime>{};
    for (final trainee in trainees) {
      if (groups.contains(trainee.trainingGroup)) {
        for (final date in trainee.attendanceDates) {
          if (date.weekday == weekday) {
            dateSet.add(DateTime(date.year, date.month, date.day));
          }
        }
      }
    }
    final dates = dateSet.toList()..sort();
    return dates;
  }

  List<GroupAttendanceData> _computeGroupCounts(
    List<Trainee> trainees,
    List<Group> groups,
    List<DateTime> dates,
  ) {
    final result = <GroupAttendanceData>[];

    for (final group in groups) {
      final counts = <DateTime, int>{};
      for (final date in dates) {
        counts[date] = 0;
      }

      for (final trainee in trainees) {
        if (trainee.trainingGroup != group) continue;
        for (final date in trainee.attendanceDates) {
          final normalizedDate = DateTime(date.year, date.month, date.day);
          if (counts.containsKey(normalizedDate)) {
            counts[normalizedDate] = counts[normalizedDate]! + 1;
          }
        }
      }

      result.add(GroupAttendanceData(group: group, counts: counts));
    }

    return result;
  }

  Map<DateTime, int> _computeSums(
    List<GroupAttendanceData> groupData,
    List<DateTime> dates,
  ) {
    final sums = <DateTime, int>{};
    for (final date in dates) {
      var sum = 0;
      for (final data in groupData) {
        sum += data.counts[date] ?? 0;
      }
      sums[date] = sum;
    }
    return sums;
  }
}
