import 'package:intl/intl.dart';

class DateService {
  static DateTime parseToDate(String dateString) {
    if (dateString == '') {
      return DateTime.now();
    }
    return DateFormat('dd.MM.yyyy').parse(dateString);
  }

  static String formatToGerman(String dateString) {
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);

    return DateFormat('dd.MM.yyyy').format(dateTime);
  }
}
