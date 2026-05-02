import 'package:training_organizer/data/email_launcher_stub.dart'
    if (dart.library.js_interop) 'package:training_organizer/data/email_launcher_web.dart';
import 'package:training_organizer/domain/repositories/email_repository.dart';

class EmailHandler implements EmailRepository {
  @override
  Future<void> sendEmail(Uri uri) async {
    await launchMailtoUri(uri);
  }
}
