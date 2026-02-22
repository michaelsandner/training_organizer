import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:training_organizer/import_export/domain/file_repository.dart';
import 'package:training_organizer/model/trainee.dart';

class FileExporter implements FileRepository {
  @override
  Future<void> exportTrainees(List<Trainee> trainees) async {
    String json = encodeJson(trainees);

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

  String encodeJson(List<Trainee> trainees) {
    Map<String, dynamic> map = {
      'trainees': trainees,
    };
    String json = jsonEncode(map);
    return json;
  }

  static Future<void> _exportFileOnWindows(String json) async {
    String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:', fileName: _getFileName());

    if (outputFile != null) {
      File saveFile = File(outputFile);

      await saveFile.writeAsString(json);
    }
  }

  static Future<void> _exportFileOnAndroid(String json) async {
    String localPath =
        await ExternalPath.getExternalStoragePublicDirectory("Downloads");

    final fileName = _getFileName();

    File saveFile = File('$localPath/$fileName');

    await saveFile.writeAsString(json);
  }

  static String _getFileName() {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;
    final currentDay = DateTime.now().day;

    return 'export_${currentYear}_${currentMonth}_$currentDay.json';
  }

  @override
  Future<void> exportCertificationAttendeesAsCsv(
      List<Trainee> trainees, String qualificationSuffix) async {
    final csv = _encodeCsv(trainees);
    final fileName = _getCsvFileName(qualificationSuffix);

    if (kIsWeb) {
      await FilePicker.platform.saveFile(
        fileName: fileName,
        bytes: utf8.encode(csv),
      );
    } else {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Speicherort wählen:',
        fileName: fileName,
        allowedExtensions: ['csv'],
        type: FileType.custom,
      );

      if (outputFile != null) {
        final saveFile = File(outputFile);
        await saveFile.writeAsString(csv);
      }
    }
  }

  String _encodeCsv(List<Trainee> trainees) {
    const separator = ';';
    final buffer = StringBuffer();
    for (final t in trainees) {
      buffer.writeln(
        '${_escapeCsv(t.forename)}$separator'
        '${_escapeCsv(t.surname)}$separator'
        '${_escapeCsv(t.dateOfBirth)}$separator'
        'Langenzenn$separator'
        'Fürth$separator'
        '$separator'
        '$separator',
      );
    }
    return buffer.toString();
  }

  String _escapeCsv(String value) {
    if (value.contains(';') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String _getCsvFileName(String qualificationSuffix) {
    final now = DateTime.now();
    return 'export_${now.year}_${now.month}_${now.day}_$qualificationSuffix.csv';
  }

  @override
  Future<List<Trainee>> importTrainees() async {
    try {
      String? json = await _importFile();

      if (json == null) {
        return [];
      }

      Map<String, dynamic> inputMap = jsonDecode(json);

      var list = inputMap['trainees'] as List;
      List<Trainee> traineeList = list.map((t) => Trainee.fromJson(t)).toList();

      return traineeList;
    } catch (e) {
      throw Exception('Failed to import file: $e');
    }
  }

  Future<String?> _importFile() async {
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
      String fileAsString = await file.readAsString();

      return fileAsString;
    }
  }
}
