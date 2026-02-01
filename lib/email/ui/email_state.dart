import 'package:equatable/equatable.dart';

enum EmailList1 {
  saturdayKids,
  saturdayKidsAndTrainer,
  wednesdayKids,
  allKids,
  trainer,
  active,
  activeAndLeasure,
  invited,
  all,
}

class EmailState with EquatableMixin {
  final bool shouldSendToSaturdayBlock5;
  final bool shouldSendToSaturdayBlock1;
  final bool shouldSendToSaturdayBlock2;
  final bool shouldSendToSaturdayBlock4;
  final bool shouldSendToAllSaturday;

  final bool shouldSendToWednesdayBlock1;
  final bool shouldSendToWednesdayBlock2;
  final bool shouldSendToActive;
  final bool shouldSendToLeisure;
  final bool shouldSendToAllWednesday;

  final bool shouldSendToTrainer;
  final bool shouldSendToWaitinglist;
  final bool shouldSendToInvited;

  const EmailState({
    required this.shouldSendToSaturdayBlock5,
    required this.shouldSendToSaturdayBlock1,
    required this.shouldSendToSaturdayBlock2,
    required this.shouldSendToSaturdayBlock4,
    required this.shouldSendToWednesdayBlock1,
    required this.shouldSendToWednesdayBlock2,
    required this.shouldSendToTrainer,
    required this.shouldSendToActive,
    required this.shouldSendToLeisure,
    required this.shouldSendToInvited,
    required this.shouldSendToWaitinglist,
    required this.shouldSendToAllSaturday,
    required this.shouldSendToAllWednesday,
  });

  factory EmailState.initial() {
    return const EmailState(
      shouldSendToSaturdayBlock5: false,
      shouldSendToSaturdayBlock1: false,
      shouldSendToSaturdayBlock2: false,
      shouldSendToSaturdayBlock4: false,
      shouldSendToWednesdayBlock1: false,
      shouldSendToWednesdayBlock2: false,
      shouldSendToTrainer: false,
      shouldSendToActive: false,
      shouldSendToLeisure: false,
      shouldSendToInvited: false,
      shouldSendToWaitinglist: false,
      shouldSendToAllSaturday: false,
      shouldSendToAllWednesday: false,
    );
  }

  EmailState copyWith({
    bool? shouldSendToSaturdayBlock5,
    bool? shouldSendToSaturdayBlock1,
    bool? shouldSendToSaturdayBlock2,
    bool? shouldSendToSaturdayBlock4,
    bool? shouldSendToWednesdayBlock1,
    bool? shouldSendToWednesdayBlock2,
    bool? shouldSendToTrainer,
    bool? shouldSendToActive,
    bool? shouldSendToLeisure,
    bool? shouldSendToInvited,
    bool? shouldSendToWaitinglist,
    bool? shouldSendToAllSaturday,
    bool? shouldSendToAllWednesday,
  }) {
    return EmailState(
      shouldSendToSaturdayBlock5:
          shouldSendToSaturdayBlock5 ?? this.shouldSendToSaturdayBlock5,
      shouldSendToSaturdayBlock1:
          shouldSendToSaturdayBlock1 ?? this.shouldSendToSaturdayBlock1,
      shouldSendToSaturdayBlock2:
          shouldSendToSaturdayBlock2 ?? this.shouldSendToSaturdayBlock2,
      shouldSendToSaturdayBlock4:
          shouldSendToSaturdayBlock4 ?? this.shouldSendToSaturdayBlock4,
      shouldSendToWednesdayBlock1:
          shouldSendToWednesdayBlock1 ?? this.shouldSendToWednesdayBlock1,
      shouldSendToWednesdayBlock2:
          shouldSendToWednesdayBlock2 ?? this.shouldSendToWednesdayBlock2,
      shouldSendToTrainer: shouldSendToTrainer ?? this.shouldSendToTrainer,
      shouldSendToActive: shouldSendToActive ?? this.shouldSendToActive,
      shouldSendToLeisure: shouldSendToLeisure ?? this.shouldSendToLeisure,
      shouldSendToInvited: shouldSendToInvited ?? this.shouldSendToInvited,
      shouldSendToWaitinglist:
          shouldSendToWaitinglist ?? this.shouldSendToWaitinglist,
      shouldSendToAllSaturday:
          shouldSendToAllSaturday ?? this.shouldSendToAllSaturday,
      shouldSendToAllWednesday:
          shouldSendToAllWednesday ?? this.shouldSendToAllWednesday,
    );
  }

  @override
  List<Object?> get props => [
        shouldSendToSaturdayBlock5,
        shouldSendToSaturdayBlock1,
        shouldSendToSaturdayBlock2,
        shouldSendToSaturdayBlock4,
        shouldSendToWednesdayBlock1,
        shouldSendToWednesdayBlock2,
        shouldSendToTrainer,
        shouldSendToActive,
        shouldSendToLeisure,
        shouldSendToInvited,
        shouldSendToLeisure,
        shouldSendToAllSaturday,
        shouldSendToAllWednesday
      ];
}
