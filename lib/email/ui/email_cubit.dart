import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/email/domain/send_email_usecase.dart';
import 'package:training_organizer/email/ui/email_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/services/trainees_filter_service.dart';

class EmailCubit extends Cubit<EmailState> {
  final SendEmailUseCase _sendEmailUseCase;
  EmailCubit(this._sendEmailUseCase) : super(EmailState.initial());

  static const _groupMapping = {
    EmailRecipientGroup.saturdayBlock1: Group.group1,
    EmailRecipientGroup.saturdayBlock2: Group.group2,
    EmailRecipientGroup.saturdayBlock4: Group.group4,
    EmailRecipientGroup.saturdayBlock5: Group.group5,
    EmailRecipientGroup.wednesdayBlock1: Group.wednesday,
    EmailRecipientGroup.wednesdayBlock2: Group.wednesday,
    EmailRecipientGroup.active: Group.active,
    EmailRecipientGroup.invited: Group.invited,
    EmailRecipientGroup.waitinglist: Group.waitingList,
  };

  void toggleGroup(EmailRecipientGroup group, bool selected) {
    final updated = Set<EmailRecipientGroup>.from(state.selectedGroups);
    selected ? updated.add(group) : updated.remove(group);
    emit(state.copyWith(selectedGroups: updated));
  }

  void selectAllSaturday(bool selected) {
    final saturdayGroups = {
      EmailRecipientGroup.saturdayBlock1,
      EmailRecipientGroup.saturdayBlock2,
      EmailRecipientGroup.saturdayBlock4,
      EmailRecipientGroup.saturdayBlock5,
    };
    _bulkToggle(saturdayGroups, selected);
  }

  void selectAllWednesday(bool selected) {
    final wednesdayGroups = {
      EmailRecipientGroup.wednesdayBlock1,
      EmailRecipientGroup.wednesdayBlock2,
    };
    _bulkToggle(wednesdayGroups, selected);
  }

  void _bulkToggle(Set<EmailRecipientGroup> groups, bool selected) {
    final updated = Set<EmailRecipientGroup>.from(state.selectedGroups);
    selected ? updated.addAll(groups) : updated.removeAll(groups);
    emit(state.copyWith(selectedGroups: updated));
  }

  Future<void> sendEmail(List<Trainee> trainees) async {
    if (!state.hasSelection) return;

    if (state.isOnlyInvitedSelected) {
      await _sendToInvited(trainees);
    } else {
      await _sendToSelectedGroups(trainees);
    }
  }

  Future<void> _sendToSelectedGroups(List<Trainee> trainees) async {
    final recipients = _filterTraineesBySelection(trainees);
    final trainers = state.isGroupSelected(EmailRecipientGroup.trainer)
        ? TraineesFilterService.getAllTrainers(trainees)
        : <Trainee>[];

    await _sendEmailUseCase.sendEmailToTrainees(recipients, trainers);
  }

  List<Trainee> _filterTraineesBySelection(List<Trainee> allTrainees) {
    final result = <Trainee>{};

    for (final selectedGroup in state.selectedGroups) {
      if (selectedGroup == EmailRecipientGroup.trainer) continue;

      final traineeGroup = _groupMapping[selectedGroup];
      if (traineeGroup != null) {
        result.addAll(TraineesFilterService.getTraineesOfGroup(
            allTrainees, traineeGroup));
      }
    }

    return result.toList();
  }

  Future<void> _sendToInvited(List<Trainee> trainees) async {
    final invited = TraineesFilterService.getTraineesOfGroup(
      trainees,
      Group.invited,
    );
    await _sendEmailUseCase.sendEmailToInvitedListTrainees(invited);
  }
}
