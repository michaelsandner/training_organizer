import 'package:web/web.dart' as web;

/// Returns true if the current browser is running on an Android device.
///
/// This is a web-only implementation. On other platforms the stub returns
/// false.
bool isAndroidBrowser() {
  return web.window.navigator.userAgent.contains('Android');
}
