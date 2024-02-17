import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/services/email_service.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';
import 'package:training_organizer/view/send_email/email_state.dart';

class EmailCubit extends Cubit<EmailState> {
  EmailCubit() : super(EmailState.initial());

  void shouldSendToWednesdayKids(bool shouldSend) {
    emit(state.copyWith(shouldSendToWednesdayKids: shouldSend));
  }

  void shouldSendToActive(bool shouldSend) {
    emit(state.copyWith(shouldSendToActive: shouldSend));
  }

  void shouldSendToTrainer(bool shouldSend) {
    emit(state.copyWith(shouldSendToTrainer: shouldSend));
  }

  void shouldSendToSaturdayKids(bool shouldSend) {
    emit(state.copyWith(shouldSendToSaturdayKids: shouldSend));
  }

  void shouldSendToInvited(bool shouldSend) {
    emit(state.copyWith(shouldSendToInvited: shouldSend));
  }

  void shouldSendToLeasure(bool shouldSend) {
    emit(state.copyWith(shouldSendToLeasure: shouldSend));
  }

  void sendEmail(List<Trainee> trainees) {
    if (_isOnlyInvitedSelcted()) {
      _sendMailToInvited(trainees);
      return;
    }

    List<Trainee> traineeList = [];

    TraineesFilterService.getAllSaturdayTrainees(trainees);

    if (state.shouldSendToSaturdayKids) {
      traineeList
          .addAll(TraineesFilterService.getAllSaturdayTrainees(trainees));
    }

    if (state.shouldSendToWednesdayKids) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.wednesday));
    }

    if (state.shouldSendToActive) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.active));
    }

    if (state.shouldSendToInvited) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.invited));
    }

    List<Trainee> trainerList = [];

    if (state.shouldSendToTrainer) {
      trainerList = TraineesFilterService.getAllTrainers(trainees);
    }

    sendMailToTrainees(traineeList, trainerList);
  }

  bool _isOnlyInvitedSelcted() {
    if (state.shouldSendToInvited &&
        !state.shouldSendToSaturdayKids &&
        !state.shouldSendToWednesdayKids &&
        !state.shouldSendToTrainer &&
        !state.shouldSendToLeasure &&
        !state.shouldSendToActive) {
      return true;
    }
    return false;
  }

  Future<void> _sendMailToInvited(List<Trainee> trainees) async {
    final selectedTrainees =
        TraineesFilterService.getTraineesOfGroup(trainees, Group.invited);

    await sendMailToInvitedListTrainees(selectedTrainees);
  }
}
