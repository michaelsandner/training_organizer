import 'package:equatable/equatable.dart';

enum EmailList {
  saturdayKids,
  saturdayKidsAndTrainer,
  wednesdayKids,
  allKids,
  trainer,
  active,
  activeAndLeasure,
  all,
}

class EmailState with EquatableMixin {
  final EmailList emailList;

  const EmailState({required this.emailList});

  factory EmailState.initial() {
    return const EmailState(
      emailList: EmailList.saturdayKids,
    );
  }

  EmailState copyWith({
    EmailList? emailList,
  }) {
    return EmailState(emailList: emailList ?? this.emailList);
  }

  @override
  List<Object?> get props => [emailList];
}
