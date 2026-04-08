import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Downloads a file in the browser with the given [bytes], [fileName] and
/// [mimeType]. The browser triggers a download dialog or saves the file
/// directly to the downloads folder, depending on the browser settings.
///
/// This is a web-only implementation. On other platforms the stub throws
/// [UnsupportedError].
Future<void> downloadFileOnWeb(
  Uint8List bytes,
  String fileName,
  String mimeType,
) async {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: mimeType),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = fileName;
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  // Revoke the URL after a short delay to ensure the browser has started
  // the download before the object URL is invalidated. The cleanup is
  // intentionally fire-and-forget: waiting 1 s for a URL revocation would
  // block the caller for no user-visible reason.
  // ignore: unawaited_futures
  Future.delayed(const Duration(seconds: 1), () {
    web.URL.revokeObjectURL(url);
  });
}
