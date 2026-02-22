import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/services/date_service.dart';

void main() {
  group('Given a date string in German format', () {
    group('When parseToDate is called', () {
      test('Then it should return the correct DateTime', () {
        String inputDate = '07.03.2023';

        DateTime outputDate = DateService.parseToDate(inputDate);

        expect(outputDate.year, 2023);
        expect(outputDate.month, 3);
        expect(outputDate.day, 7);
      });
    });
  });

  group('Given a date string in ISO format', () {
    group('When formatToGerman is called', () {
      test('Then it should return the date in German format', () {
        String inputDate = '2023-03-07';

        String output = DateService.formatToGerman(inputDate);

        expect(output, '07.03.2023');
      });
    });
  });
}
