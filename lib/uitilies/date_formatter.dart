import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

final log = Logger();

class DateFormatter {
  /// Parses a date string (e.g., "2025-10-10") and formats it
  /// as "[DAY] [FULL MONTH NAME] [YEAR], 12:00 - 00:00" (e.g., "10 OCTOBER 2025, 12:00 - 00:00").
  static String formatEventDate(String dateString) {
    if (dateString.isEmpty) {
      return 'Date not available';
    }

    try {
      final DateTime date = DateTime.parse(dateString);

      final DateFormat formatter = DateFormat('d MMMM y');
      final String formattedDate = formatter.format(date).toUpperCase();

      return '$formattedDate, 12:00 - 00:00';
    } catch (e) {
      log.e(" ❌ Error formatting date: $e. Input: $dateString");
      return dateString;
    }
  }
}