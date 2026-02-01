import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/email/domain/send_email_usecase.dart';
import 'package:training_organizer/email/ui/email_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';

class EmailCubit extends Cubit<EmailState> {
  final SendEmailUseCase _sendEmailUseCase;
  EmailCubit(this._sendEmailUseCase) : super(EmailState.initial());

  void shouldSendToSaturdayBlock5(bool shouldSend) {
    emit(state.copyWith(shouldSendToSaturdayBlock5: shouldSend));
    _updateStates();
  }

  void shouldSendToSaturdayBlock1(bool shouldSend) {
    emit(state.copyWith(shouldSendToSaturdayBlock1: shouldSend));
    _updateStates();
  }

  void shouldSendToSaturdayBlock2(bool shouldSend) {
    emit(state.copyWith(shouldSendToSaturdayBlock2: shouldSend));
    _updateStates();
  }

  void shouldSendToSaturdayBlock4(bool shouldSend) {
    emit(state.copyWith(shouldSendToSaturdayBlock4: shouldSend));
    _updateStates();
  }

  void shouldSendToWednesdayBlock1(bool shouldSend) {
    emit(state.copyWith(shouldSendToWednesdayBlock1: shouldSend));
    _updateStates();
  }

  void shouldSendToWednesdayBlock2(bool shouldSend) {
    emit(state.copyWith(shouldSendToWednesdayBlock2: shouldSend));
    _updateStates();
  }

  void shouldSendToTrainer(bool shouldSend) {
    emit(state.copyWith(shouldSendToTrainer: shouldSend));
    _updateStates();
  }

  void shouldSendToActive(bool shouldSend) {
    emit(state.copyWith(shouldSendToActive: shouldSend));
    _updateStates();
  }

  void shouldSendToLeisure(bool shouldSend) {
    emit(state.copyWith(shouldSendToLeisure: shouldSend));
    _updateStates();
  }

  void shouldSendToWaitinglist(bool shouldSend) {
    emit(state.copyWith(shouldSendToWaitinglist: shouldSend));
    _updateStates();
  }

  void shouldSendToInvited(bool shouldSend) {
    emit(state.copyWith(shouldSendToInvited: shouldSend));
    _updateStates();
  }

  void shouldSendToAllSaturday(bool shouldSend) {
    emit(state.copyWith(shouldSendToAllSaturday: shouldSend));
    _updateStates();
  }

  void shouldSendToAllWednesday(bool shouldSend) {
    emit(state.copyWith(shouldSendToAllWednesday: shouldSend));
    _updateStates();
  }

  void _updateStates() {
    if (state.shouldSendToAllSaturday) {
      emit(state.copyWith(
        shouldSendToSaturdayBlock1: true,
        shouldSendToSaturdayBlock2: true,
        shouldSendToSaturdayBlock4: true,
        shouldSendToSaturdayBlock5: true,
      ));
      if (state.shouldSendToAllWednesday) {
        emit(state.copyWith(
            shouldSendToWednesdayBlock1: true,
            shouldSendToWednesdayBlock2: true,
            shouldSendToLeisure: true,
            shouldSendToActive: true));
      }
      if (!state.shouldSendToSaturdayBlock1 ||
          !state.shouldSendToSaturdayBlock2 ||
          !state.shouldSendToSaturdayBlock4 ||
          !state.shouldSendToSaturdayBlock5) {
        emit(state.copyWith(shouldSendToAllSaturday: false));
      }
      if (!state.shouldSendToWednesdayBlock1 ||
          !state.shouldSendToWednesdayBlock2 ||
          !state.shouldSendToLeisure ||
          !state.shouldSendToActive) {
        emit(state.copyWith(shouldSendToAllWednesday: false));
      }
    }
  }

  Future<void> sendEmail(List<Trainee> trainees) async {
    if (_isOnlyInvitedSelcted()) {
      await _sendMailToInvited(trainees);
      return;
    }

    List<Trainee> traineeList = [];

    TraineesFilterService.getAllSaturdayTrainees(trainees);

    if (state.shouldSendToWednesdayBlock1) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.wednesday));
    }

    if (state.shouldSendToWednesdayBlock2) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.wednesday));
    }

    if (state.shouldSendToSaturdayBlock1) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.group1));
    }

    if (state.shouldSendToSaturdayBlock2) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.group2));
    }
    if (state.shouldSendToSaturdayBlock4) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.group4));
    }
    if (state.shouldSendToSaturdayBlock5) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.group5));
    }

    if (state.shouldSendToActive) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.active));
    }

    if (state.shouldSendToInvited) {
      traineeList.addAll(
          TraineesFilterService.getTraineesOfGroup(trainees, Group.invited));
    }

    if (state.shouldSendToInvited) {
      traineeList.addAll(TraineesFilterService.getTraineesOfGroup(
          trainees, Group.waitingList));
    }

    List<Trainee> trainerList = [];

    if (state.shouldSendToTrainer) {
      trainerList = TraineesFilterService.getAllTrainers(trainees);
    }

    await _sendEmailUseCase.sendEmailToTrainees(traineeList, trainerList);
  }

  bool _isOnlyInvitedSelcted() {
    if (state.shouldSendToInvited &&
        !state.shouldSendToSaturdayBlock1 &&
        !state.shouldSendToSaturdayBlock2 &&
        !state.shouldSendToSaturdayBlock5 &&
        !state.shouldSendToSaturdayBlock4 &&
        !state.shouldSendToWednesdayBlock1 &&
        !state.shouldSendToWednesdayBlock2 &&
        !state.shouldSendToTrainer &&
        !state.shouldSendToLeisure &&
        !state.shouldSendToActive) {
      return true;
    }
    return false;
  }

  Future<void> _sendMailToInvited(List<Trainee> trainees) async {
    final selectedTrainees =
        TraineesFilterService.getTraineesOfGroup(trainees, Group.invited);

    await _sendEmailUseCase.sendEmailToInvitedListTrainees(selectedTrainees);
  }
}
