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
  final bool shouldSendToSaturdayKids;
  final bool shouldSendToWednesdayKids;
  final bool shouldSendToTrainer;
  final bool shouldSendToActive;
  final bool shouldSendToLeasure;
  final bool shouldSendToInvited;

  const EmailState({
    required this.shouldSendToSaturdayKids,
    required this.shouldSendToWednesdayKids,
    required this.shouldSendToActive,
    required this.shouldSendToLeasure,
    required this.shouldSendToTrainer,
    required this.shouldSendToInvited,
  });

  factory EmailState.initial() {
    return const EmailState(
      shouldSendToSaturdayKids: false,
      shouldSendToWednesdayKids: false,
      shouldSendToActive: false,
      shouldSendToTrainer: false,
      shouldSendToInvited: false,
      shouldSendToLeasure: false,
    );
  }

  EmailState copyWith({
    bool? shouldSendToSaturdayKids,
    bool? shouldSendToWednesdayKids,
    bool? shouldSendToTrainer,
    bool? shouldSendToActive,
    bool? shouldSendToLeasure,
    bool? shouldSendToInvited,
  }) {
    return EmailState(
      shouldSendToSaturdayKids:
          shouldSendToSaturdayKids ?? this.shouldSendToSaturdayKids,
      shouldSendToWednesdayKids:
          shouldSendToWednesdayKids ?? this.shouldSendToWednesdayKids,
      shouldSendToTrainer: shouldSendToTrainer ?? this.shouldSendToTrainer,
      shouldSendToActive: shouldSendToActive ?? this.shouldSendToActive,
      shouldSendToLeasure: shouldSendToLeasure ?? this.shouldSendToLeasure,
      shouldSendToInvited: shouldSendToInvited ?? this.shouldSendToInvited,
    );
  }

  @override
  List<Object?> get props => [
        shouldSendToActive,
        shouldSendToInvited,
        shouldSendToLeasure,
        shouldSendToSaturdayKids,
        shouldSendToTrainer,
        shouldSendToWednesdayKids,
      ];
}
