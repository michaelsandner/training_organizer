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

enum EmailRecipientGroup {
  saturdayBlock1,
  saturdayBlock2,
  saturdayBlock4,
  saturdayBlock5,
  wednesdayBlock1,
  wednesdayBlock2,
  trainer,
  active,
  leisure,
  waitinglist,
  invited,
}

class EmailState with EquatableMixin {
  // final bool shouldSendToSaturdayBlock5;
  // final bool shouldSendToSaturdayBlock1;
  // final bool shouldSendToSaturdayBlock2;
  // final bool shouldSendToSaturdayBlock4;
  // final bool shouldSendToAllSaturday;

  // final bool shouldSendToWednesdayBlock1;
  // final bool shouldSendToWednesdayBlock2;
  // final bool shouldSendToActive;
  // final bool shouldSendToLeisure;
  // final bool shouldSendToAllWednesday;

  // final bool shouldSendToTrainer;
  // final bool shouldSendToWaitinglist;
  // final bool shouldSendToInvited;

  final Set<EmailRecipientGroup> selectedGroups;

  const EmailState({
    // required this.shouldSendToSaturdayBlock5,
    // required this.shouldSendToSaturdayBlock1,
    // required this.shouldSendToSaturdayBlock2,
    // required this.shouldSendToSaturdayBlock4,
    // required this.shouldSendToWednesdayBlock1,
    // required this.shouldSendToWednesdayBlock2,
    // required this.shouldSendToTrainer,
    // required this.shouldSendToActive,
    // required this.shouldSendToLeisure,
    // required this.shouldSendToInvited,
    // required this.shouldSendToWaitinglist,
    // required this.shouldSendToAllSaturday,
    // required this.shouldSendToAllWednesday,
    this.selectedGroups = const {},
  });

  factory EmailState.initial() => const EmailState();

  EmailState copyWith({
    // bool? shouldSendToSaturdayBlock5,
    // bool? shouldSendToSaturdayBlock1,
    // bool? shouldSendToSaturdayBlock2,
    // bool? shouldSendToSaturdayBlock4,
    // bool? shouldSendToWednesdayBlock1,
    // bool? shouldSendToWednesdayBlock2,
    // bool? shouldSendToTrainer,
    // bool? shouldSendToActive,
    // bool? shouldSendToLeisure,
    // bool? shouldSendToInvited,
    // bool? shouldSendToWaitinglist,
    // bool? shouldSendToAllSaturday,
    // bool? shouldSendToAllWednesday,
    Set<EmailRecipientGroup>? selectedGroups,
  }) {
    return EmailState(
      // shouldSendToSaturdayBlock5:
      //     shouldSendToSaturdayBlock5 ?? this.shouldSendToSaturdayBlock5,
      // shouldSendToSaturdayBlock1:
      //     shouldSendToSaturdayBlock1 ?? this.shouldSendToSaturdayBlock1,
      // shouldSendToSaturdayBlock2:
      //     shouldSendToSaturdayBlock2 ?? this.shouldSendToSaturdayBlock2,
      // shouldSendToSaturdayBlock4:
      //     shouldSendToSaturdayBlock4 ?? this.shouldSendToSaturdayBlock4,
      // shouldSendToWednesdayBlock1:
      //     shouldSendToWednesdayBlock1 ?? this.shouldSendToWednesdayBlock1,
      // shouldSendToWednesdayBlock2:
      //     shouldSendToWednesdayBlock2 ?? this.shouldSendToWednesdayBlock2,
      // shouldSendToTrainer: shouldSendToTrainer ?? this.shouldSendToTrainer,
      // shouldSendToActive: shouldSendToActive ?? this.shouldSendToActive,
      // shouldSendToLeisure: shouldSendToLeisure ?? this.shouldSendToLeisure,
      // shouldSendToInvited: shouldSendToInvited ?? this.shouldSendToInvited,
      // shouldSendToWaitinglist:
      //     shouldSendToWaitinglist ?? this.shouldSendToWaitinglist,
      // shouldSendToAllSaturday:
      //     shouldSendToAllSaturday ?? this.shouldSendToAllSaturday,
      // shouldSendToAllWednesday:
      //     shouldSendToAllWednesday ?? this.shouldSendToAllWednesday,
      selectedGroups: selectedGroups ?? this.selectedGroups,
    );
  }

  bool get hasSelection => selectedGroups.isNotEmpty;

  bool isGroupSelected(EmailRecipientGroup group) =>
      selectedGroups.contains(group);

  bool get isOnlyInvitedSelected =>
      selectedGroups.length == 1 &&
      selectedGroups.contains(EmailRecipientGroup.invited);

  @override
  List<Object?> get props => [
        // shouldSendToSaturdayBlock5,
        // shouldSendToSaturdayBlock1,
        // shouldSendToSaturdayBlock2,
        // shouldSendToSaturdayBlock4,
        // shouldSendToWednesdayBlock1,
        // shouldSendToWednesdayBlock2,
        // shouldSendToTrainer,
        // shouldSendToActive,
        // shouldSendToLeisure,
        // shouldSendToInvited,
        // shouldSendToLeisure,
        // shouldSendToAllSaturday,
        // shouldSendToAllWednesday
        selectedGroups
      ];
}
