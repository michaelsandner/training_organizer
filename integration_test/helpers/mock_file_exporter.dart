import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:training_organizer/data/file_handler.dart';
import 'package:training_organizer/model/trainee.dart';

class MockTestTraineeFileExporter extends FileExporter {
  @override
  Future<List<Trainee>> importTrainees() async {
    final jsonString = await rootBundle.loadString(
      'assets/test_data/test_trainees.json',
    );
    final Map<String, dynamic> inputMap = jsonDecode(jsonString);
    final list = inputMap['trainees'] as List;
    return list.map((t) => Trainee.fromJson(t)).toList();
  }

  @override
  Future<void> exportTrainees(List<Trainee> trainees) async {}

  @override
  Future<void> exportCertificationAttendeesAsCsv(
    List<Trainee> trainees,
    String qualificationSuffix,
  ) async {}
}
