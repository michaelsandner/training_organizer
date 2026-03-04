import 'package:training_organizer/email/domain/email_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailHandler implements EmailRepository {
  @override
  Future<void> sendEmail(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
