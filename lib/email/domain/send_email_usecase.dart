import 'package:training_organizer/email/domain/email_repository.dart';
import 'package:training_organizer/email/domain/template_strings.dart';
import 'package:training_organizer/model/trainee.dart';

class SendEmailUseCase {
  final EmailRepository _emailRepository;

  SendEmailUseCase(this._emailRepository);

  Future<void> sendEmailToSingleTrainee(Trainee trainee) async {
    String email = trainee.email;
    final uri = Uri.parse('mailto:$email');
    await _emailRepository.sendEmail(uri);
  }

  Future<void> sendEmailToInvitedListTrainees(List<Trainee> trainees) async {
    String email = _getEmails(trainees);
    String cc = 'info@wasserwacht-langenzeen.de';

    final String subject = Uri.encodeComponent(getInvitedInvitationSubject());

    final String body = Uri.encodeComponent(getInvitedInvitationContent());
    final uri =
        Uri.parse('mailto:?bcc=$email&cc=$cc&subject=$subject&body=$body');
    await _emailRepository.sendEmail(uri);
  }

  Future<void> sendEmailToSingleWaitingListTrainee(Trainee trainee) async {
    String email = trainee.email;
    String bcc = "info@wasserwacht-langenzenn.de";
    String foreName = trainee.forename;
    String registrationDate = trainee.registrationDate;

    final String subject = Uri.encodeComponent(getWaitingListAcceptSubject());
    final String body = Uri.encodeComponent(
        getWaitingListAcceptContent(foreName, registrationDate));
    final uri = Uri.parse('mailto:$email?bcc=$bcc&subject=$subject&body=$body');
    await _emailRepository.sendEmail(uri);
  }

  Future<void> sendEmailToTrainees(
      List<Trainee> trainees, List<Trainee> copyTo) async {
    String email = _getEmails(trainees);
    String copy = _getEmails(copyTo);
    String bcc = '$email$copy';

    final uri = Uri.parse('mailto:?bcc=$bcc');
    await _emailRepository.sendEmail(uri);
  }
}

String _getEmails(List<Trainee> trainees) {
  String email = '';
  for (var element in trainees) {
    if (element.email != '' && element.email != 'null') {
      email += ',${element.email}';
    }
  }
  return email;
}
