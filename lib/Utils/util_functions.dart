import 'package:intl/intl.dart';

class UtilFunctions {
  static String formatDateString(String dateString) {
    DateTime parsedDate = DateTime.parse(dateString);
    // String daySuffix = _getDayOfMonthSuffix(parsedDate.day);
    String formattedDate = DateFormat("dd MMM yyyy").format(parsedDate);
    return formattedDate;
  }
}
