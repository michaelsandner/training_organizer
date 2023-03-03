import 'dart:io';

import 'package:flutter/foundation.dart';

bool isMobile() {
  if (kIsWeb) {
    return false;
  }
  if (Platform.isAndroid || Platform.isIOS) {
    return true;
  }
  return false;
}
