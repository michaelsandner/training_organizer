import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileService {
  static Future<String?> importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) {
      return null;
    }

    if (kIsWeb) {
      String test = utf8.decode(result.files.single.bytes!);
      return test;
    } else {
      File file;
      file = File(result.files.single.path!);
      return await file.readAsString();
    }
  }

  static Future<void> exportFile(String json) async {
    if (Platform.isWindows) {
      await exportFileOnWindows(json);
    } else {
      await exportFileOnAndroid(json);
    }
  }

  static Future<void> exportFileOnWindows(String json) async {
    String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:', fileName: 't.json');

    if (outputFile != null) {
      File saveFile = File(outputFile);

      await saveFile.writeAsString(json);
    }
  }

  static Future<void> exportFileOnAndroid(String json) async {
    String localPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    File saveFile = File('$localPath/t.json');

    await saveFile.writeAsString(json);
  }
}
