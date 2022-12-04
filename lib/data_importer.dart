import 'dart:io';

import 'package:training_organizer/trainee.dart';

class DataImporter {
  String getTraineesFromFile(String filePath) {
    File file = File(filePath);
    return file.readAsStringSync();
  }

  List<Trainee> getTrainees(String filePath) {
    final content = getTraineesFromFile(filePath);

    return List<Trainee>.empty();
  }
}
