import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileService {
  static Future<String?> importFile(
      Function(bool shouldShowLoadingSpinner) toggleShowLoadingSpinner) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) {
      return null;
    }

    toggleShowLoadingSpinner(true);

    if (kIsWeb) {
      String test = utf8.decode(result.files.single.bytes!);
      toggleShowLoadingSpinner(false);
      return test;
    } else {
      File file;
      file = File(result.files.single.path!);
      String fileAsString = await file.readAsString();
      toggleShowLoadingSpinner(false);
      return fileAsString;
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
        dialogTitle: 'Please select an output file:', fileName: getFileName());

    if (outputFile != null) {
      File saveFile = File(outputFile);

      await saveFile.writeAsString(json);
    }
  }

  static Future<void> exportFileOnAndroid(String json) async {
    String localPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    final fileName = getFileName();

    File saveFile = File('$localPath/$fileName');

    await saveFile.writeAsString(json);
  }

  static String getFileName() {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;
    final currentDay = DateTime.now().day;

    return 'export_${currentYear}_${currentMonth}_$currentDay.json';
  }
}
