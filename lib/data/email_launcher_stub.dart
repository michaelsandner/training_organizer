import 'package:url_launcher/url_launcher.dart';

/// Launches the given [uri] using the platform's native URL launcher.
///
/// This stub implementation is used on all platforms except web.
Future<void> launchMailtoUri(Uri uri) async {
  await launchUrl(uri);
}
