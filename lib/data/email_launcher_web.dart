import 'package:web/web.dart' as web;

/// Launches the given [uri] by simulating an anchor element click.
///
/// This web implementation creates a hidden anchor element with the mailto:
/// href and clicks it programmatically. This approach is more reliable on
/// mobile web browsers than [window.open()] because it is not blocked by
/// popup blockers and properly triggers the device email client.
Future<void> launchMailtoUri(Uri uri) async {
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = uri.toString();
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
}
