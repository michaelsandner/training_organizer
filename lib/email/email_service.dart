import 'package:training_organizer/email/template_strings.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> sendMailToTrainees(
    List<Trainee> trainees, List<Trainee> copyTo) async {
  String email = _getEmails(trainees);
  String copy = _getEmails(copyTo);

  final Uri uri = Uri.parse('mailto:$copy?bcc=$email');

  await _launchUri(uri);
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

Future<void> sendMailToSingleTrainee(Trainee trainee) async {
  String email = trainee.email;
  Uri uri = Uri.parse('mailto:$email');
  await _launchUri(uri);
}

Future<void> sendMailToSingleWaitingListTrainee(Trainee trainee) async {
  String email = trainee.email;
  String bcc = "info@wasserwacht-langenzenn.de";
  String foreName = trainee.forename;
  String registrationDate = trainee.registrationDate;

  final String subject = Uri.encodeComponent(getWaitingListAcceptSubject());
  final String body = Uri.encodeComponent(
      getWaitingListAcceptContent(foreName, registrationDate));
  Uri uri = Uri.parse('mailto:$email?bcc=$bcc&subject=$subject&body=$body');

  await _launchUri(uri);
}

Future<void> sendMailToInvitedListTrainees(List<Trainee> trainees) async {
  String email = _getEmails(trainees);
  String cc = 'info@wasserwacht-langenzeen.de';

  final String subject = Uri.encodeComponent(getInvitedInvitationSubject());

  final String body = Uri.encodeComponent(getInvitedInvitationContent());
  Uri uri = Uri.parse('mailto:?bcc=$email&cc=$cc&subject=$subject&body=$body');

  await _launchUri(uri);
}

Future<void> _launchUri(Uri uri) async {
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
