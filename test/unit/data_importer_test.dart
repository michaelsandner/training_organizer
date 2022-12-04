import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:training_organizer/data_importer.dart';
import 'package:training_organizer/trainee.dart';

main() {
  group('DataImporter', () {
    test('read file', () async {
      final filePath = await getApplicationDocumentsDirectory();
      List<Trainee> trainees =
          DataImporter().getTrainees('../test/unit/test_data.json');

      expect(trainees.length, 2);
    });
  });
}
