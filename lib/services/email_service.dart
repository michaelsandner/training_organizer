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

  final String subject =
      Uri.encodeComponent('Aufnahme Warteliste der Wasserwacht Langenzenn');
  final String body = Uri.encodeComponent('''hallo zusammen,
        hiermit bestätigen wir die Aufnahme von $foreName auf unsere Warteliste.    

        Viele Grüße

        Euer Wasserwacht-Team
         ''');
  Uri uri = Uri.parse('mailto:$email?bcc=$bcc&subject=$subject&body=$body');

  await _launchUri(uri);
}

Future<void> sendMailToWaitingListTrainees(List<Trainee> trainees) async {
  String email = _getEmails(trainees);

  final String subject = Uri.encodeComponent(
      'Aufnahme für das Schimmtraining der Wasserwacht Langenzenn');
  final String body = Uri.encodeComponent('''hallo zusammen :)
        leider hat es etwas gedauert aber nun freuen wir uns euch mitteilen zu dürfen, dass ihr endlich bei uns im Schwimmtraining mitmachen dürft.
        Dafür würden wir euch gerne zum Schnuppertraining am XXX um 17:00 Uhr am Hallenbad Langenzenn einladen.
        Das Training startet geht von 17-18 Uhr. Wir treffen uns allerdings schon kurz vorher um euch ein paar Infos zum Trainingsablauf zu geben und den Kids das Hallenbad zu zeigen.
        Bitte gebt uns bescheid ob ihr noch Interesse habt und ob ihr am Termin teilnehmen könnt.
        (Falls ihr kein Interesse mehr am Schwimmtraining habt, bitte ebenfalls bescheid geben.)

        PS: Falls ihr die Email mehrmals bekommt und sich mehrer Kinder von euch auf der Warteliste befinden, sind mehrere Kinder eingeladen ;)

        Viele Grüße

        Euer Wasserwacht-Team
         ''');
  Uri uri = Uri.parse('mailto:?bcc=$email&subject=$subject&body=$body');

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
