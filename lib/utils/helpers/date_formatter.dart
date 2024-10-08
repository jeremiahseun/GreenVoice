import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatDateWithTime(DateTime? date) {
    if (date == null) return 'Unknown';
    return DateFormat('MMM d, yyyy h:mm a').format(date);
  }
}
