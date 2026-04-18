import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:training_organizer/data/web_downloader_stub.dart'
    if (dart.library.js_interop) 'package:training_organizer/data/web_downloader_web.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_collection_repository.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_collection.dart';

class ExerciseCollectionFileHandler implements ExerciseCollectionRepository {
  @override
  Future<List<ExercisePlanCollection>?> importCollections() async {
    try {
      final json = await _importFile();
      if (json == null) return null;

      final Map<String, dynamic> inputMap = jsonDecode(json);
      final list = inputMap['collections'] as List<dynamic>;
      return list
          .map((e) =>
              ExercisePlanCollection.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Import der Trainingspläne fehlgeschlagen: $e');
    }
  }

  @override
  Future<void> exportCollections(
      List<ExercisePlanCollection> collections, String fileName) async {
    final map = {
      'collections': collections.map((c) => c.toJson()).toList(),
    };
    final json = jsonEncode(map);

    if (kIsWeb) {
      await downloadFileOnWeb(
        Uint8List.fromList(utf8.encode(json)),
        '$fileName.json',
        'application/json',
      );
    } else if (Platform.isWindows) {
      await _exportFileOnWindows(json, fileName);
    } else {
      await _exportFileOnAndroid(json, fileName);
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

  static Future<void> _exportFileOnWindows(
      String json, String fileName) async {
    final outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Speicherort für Trainingspläne wählen:',
      fileName: '$fileName.json',
    );

    if (outputFile != null) {
      final saveFile = File(outputFile);
      await saveFile.writeAsString(json);
    }
  }

  static Future<void> _exportFileOnAndroid(
      String json, String fileName) async {
    final localPath =
        await ExternalPath.getExternalStoragePublicDirectory('Downloads');
    final saveFile = File('$localPath/$fileName.json');
    await saveFile.writeAsString(json);
  }
}
