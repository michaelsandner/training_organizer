import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/cubit/email_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/services/email_service.dart';

class EmailCubit extends Cubit<EmailState> {
  EmailCubit() : super(EmailState.initial());

  void setEmailList(EmailList? emailList) {
    emit(state.copyWith(emailList: emailList));
  }

  void sendEmail(List<Trainee> trainees) {
    switch (state.emailList) {
      case EmailList.saturdayKids:
        sendMailToSaturdayKids(trainees);
        break;
      case EmailList.saturdayKidsAndTrainer:
        sendMailToSaturdayKidsAndTrainer(trainees);
        break;
      case EmailList.wednesdayKids:
        sendMailToGroup(trainees, Group.wednesday);
        break;
      case EmailList.active:
        sendMailToGroup(trainees, Group.active);
        break;
      case EmailList.all:
        sendMailToTrainees(trainees, []);
        break;
      case EmailList.trainer:
        sendMailToTrainer(trainees);
        break;
      case EmailList.activeAndLeasure:
        sendMailToGroup(trainees, Group.active);
        break;
    }
  }
}

Future<void> sendMailToGroup(List<Trainee> trainees, Group group) async {
  final selectedTrainees =
      trainees.where((element) => element.trainingGroup == group).toList();

  await sendMailToTrainees(selectedTrainees, []);
}

Future<void> sendMailToTrainer(List<Trainee> trainees) async {
  await sendMailToTrainees(_getTrainer(trainees), []);
}

Future<void> sendMailToSaturdayKids(List<Trainee> trainees) async {
  final saturdayTrainees = _getSaturdayKids(trainees);

  await sendMailToTrainees(saturdayTrainees, []);
}

Future<void> sendMailToSaturdayKidsAndTrainer(List<Trainee> trainees) async {
  final saturdayTrainees = _getSaturdayKids(trainees);

  List<Trainee> trainer = _getTrainer(trainees);

  await sendMailToTrainees(saturdayTrainees, trainer);
}

List<Trainee> _getTrainer(List<Trainee> trainees) {
  return trainees.where((element) => element.isTrainer).toList();
}

List<Trainee> _getSaturdayKids(List<Trainee> trainees) {
  return trainees
      .where((element) =>
          element.trainingGroup == Group.group1 ||
          element.trainingGroup == Group.group2 ||
          element.trainingGroup == Group.group3 ||
          element.trainingGroup == Group.group4 ||
          element.trainingGroup == Group.group5)
      .toList();
}
