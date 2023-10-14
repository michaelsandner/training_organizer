import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/cubit/email_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/services/email_service.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';

class EmailCubit extends Cubit<EmailState> {
  EmailCubit() : super(EmailState.initial());

  void setEmailList(EmailList? emailList) {
    emit(state.copyWith(emailList: emailList));
  }

  void sendEmail(List<Trainee> trainees) {
    switch (state.emailList) {
      case EmailList.saturdayKids:
        sendMailToTrainees(
            TraineesFilterService.getAllSaturdayTrainees(trainees), []);
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
        sendMailToTrainees(_getTrainer(trainees), []);
        break;
      case EmailList.activeAndLeasure:
        sendMailToGroup(trainees, Group.active);
        break;
      case EmailList.allKids:
        sendMailToTrainees(TraineesFilterService.getAllKids(trainees), []);
        break;
      case EmailList.invited:
        sendMailToGroup(trainees, Group.invited);
        break;
    }
  }
}

Future<void> sendMailToGroup(List<Trainee> trainees, Group group) async {
  final selectedTrainees =
      TraineesFilterService.getTraineesOfGroup(trainees, group);

  await sendMailToTrainees(selectedTrainees, []);
}

Future<void> sendMailToInvited(List<Trainee> trainees) async {
  final selectedTrainees =
      TraineesFilterService.getTraineesOfGroup(trainees, Group.invited);

  await sendMailToInvitedListTrainees(selectedTrainees);
}

Future<void> sendMailToTrainer(List<Trainee> trainees) async {
  await sendMailToTrainees(TraineesFilterService.getAllTrainers(trainees), []);
}

Future<void> sendMailToSaturdayKids(List<Trainee> trainees) async {
  final saturdayTrainees =
      TraineesFilterService.getAllSaturdayTrainees(trainees);

  await sendMailToTrainees(saturdayTrainees, []);
}

Future<void> sendMailToSaturdayKidsAndTrainer(List<Trainee> trainees) async {
  final saturdayTrainees =
      TraineesFilterService.getAllSaturdayTrainees(trainees);

  List<Trainee> trainer = TraineesFilterService.getAllTrainers(trainees);

  await sendMailToTrainees(saturdayTrainees, trainer);
}

List<Trainee> _getTrainer(List<Trainee> trainees) {
  return trainees.where((element) => element.isTrainer).toList();
}
