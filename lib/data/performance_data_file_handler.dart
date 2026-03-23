import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:training_organizer/domain/performance_data.dart';
import 'package:training_organizer/domain/performance_data_repository.dart';

class PerformanceDataFileHandler implements PerformanceDataRepository {
  @override
  Future<PerformanceData?> importPerformanceData() async {
    try {
      final json = await _importFile();
      if (json == null) return null;

      final Map<String, dynamic> inputMap = jsonDecode(json);
      return PerformanceData.fromJson(inputMap);
    } catch (e) {
      throw Exception('Import der Leistungsdaten fehlgeschlagen: $e');
    }
  }

  @override
  Future<void> exportPerformanceData(PerformanceData data) async {
    final json = jsonEncode(data.toJson());

    if (kIsWeb) {
      await FilePicker.platform.saveFile(
        fileName: _getFileName(),
        bytes: utf8.encode(json),
      );
    } else if (Platform.isWindows) {
      await _exportFileOnWindows(json);
    } else {
      await _exportFileOnAndroid(json);
    }
  }

  Future<String?> _importFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) return null;

    if (kIsWeb) {
      return utf8.decode(result.files.single.bytes!);
    } else {
      final file = File(result.files.single.path!);
      return file.readAsString();
    }
  }

  static Future<void> _exportFileOnWindows(String json) async {
    final outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Speicherort für Leistungsdaten wählen:',
      fileName: _getFileName(),
    );

    if (outputFile != null) {
      final saveFile = File(outputFile);
      await saveFile.writeAsString(json);
    }
  }

  static Future<void> _exportFileOnAndroid(String json) async {
    final localPath =
        await ExternalPath.getExternalStoragePublicDirectory('Downloads');
    final fileName = _getFileName();
    final saveFile = File('$localPath/$fileName');
    await saveFile.writeAsString(json);
  }

  static String _getFileName() {
    final now = DateTime.now();
    final date = '${now.year}_${now.month}_${now.day}';
    final time =
        '${now.hour.toString().padLeft(2, '0')}_${now.minute.toString().padLeft(2, '0')}_${now.second.toString().padLeft(2, '0')}';
    return 'performance_data_${date}_$time.json';
  }
}
