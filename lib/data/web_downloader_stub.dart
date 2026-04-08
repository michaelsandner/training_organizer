import 'dart:typed_data';

/// Stub implementation of [downloadFileOnWeb] for non-web platforms.
///
/// This function is never called at runtime on non-web platforms because all
/// call sites are guarded by [kIsWeb]. It exists only so that the conditional
/// import compiles on every platform.
Future<void> downloadFileOnWeb(
  Uint8List bytes,
  String fileName,
  String mimeType,
) {
  throw UnsupportedError('downloadFileOnWeb is not supported on this platform');
}
