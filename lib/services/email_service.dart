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
  String foreName = trainee.forename;

  final String subject = Uri.encodeComponent(
      'Aufnahme für das Schimmtraining der Wasserwacht Langenzenn');
  final String body = Uri.encodeComponent('''hallo zusammen :)
        leider hat es etwas gedauert aber nun freuen wir uns euch mitteilen zu dürfen, dass $foreName endlich bei uns im Schwimmtraining mitmachen darf.
        Dafür würden wir $foreName gerne zum Schnuppertraining am XXX um 17:00 Uhr am Hallenbad Langenzenn einladen.
        Wir treffen uns kurz vorher um ein paar Fragen auszutauschen und gemeinsam die Abläufe zu erklären.
        Bitte gebt uns bescheid ob ihr noch Interesse habt und ob ihr am Termin teilnehmen könnt.

        Viele Grüße

        Euer Wasserwacht-Team
         ''');
  Uri uri = Uri.parse('mailto:$email?subject=$subject&body=$body');

  await _launchUri(uri);
}

Future<void> sendMailAccecptedToWaitingList(
    String email, String foreName) async {
  Uri uri = Uri.parse('mailto:$email');
  final String subject =
      Uri.encodeComponent('Bestätigung Aufnahme Warteliste OG Langenzenn');
  final String body = Uri.encodeComponent('''hallo zusammen,
        hiermit bestätigen wir euch die Aufnahme von $foreName auf unsere Warteliste zum .

        Viele Grüße

        Euer Wasserwacht-Team
         ''');
  uri = Uri.parse('mailto:$email?subject=$subject&body=$body');

  await _launchUri(uri);
}

Future<void> _launchUri(Uri uri) async {
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
