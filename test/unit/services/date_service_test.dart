import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/services/date_service.dart';

void main() {
  group('DateService', () {
    test('ParseToDate', () {
      String inputDate = '07.03.2023';

      DateTime outputDate = DateService.parseToDate(inputDate);

      expect(outputDate.year, 2023);
      expect(outputDate.month, 3);
      expect(outputDate.day, 7);
    });
    test('FormatToGerman', () {
      String inputDate = '2023-03-07';

      String output = DateService.formatToGerman(inputDate);

      expect(output, '07.03.2023');
    });
  });
}
