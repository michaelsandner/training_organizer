/// Stub implementation of [isAndroidBrowser] for non-web platforms.
///
/// This function always returns false on non-web platforms because all
/// call sites are guarded by the conditional import. It exists only so
/// that the conditional import compiles on every platform.
bool isAndroidBrowser() => false;
