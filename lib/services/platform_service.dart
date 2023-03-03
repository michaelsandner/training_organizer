import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isMobile(Size screenSize) {
  if (kIsWeb) {
    if (screenSize.width < 500) {
      return true;
    }
    return false;
  }
  if (Platform.isAndroid || Platform.isIOS) {
    return true;
  }
  return false;
}
