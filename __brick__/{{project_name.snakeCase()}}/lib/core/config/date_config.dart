import 'package:intl/intl.dart';

class DateConfig {
  static String dateFormat(DateTime date, [String locale = 'en_US']) =>
      DateFormat('dd MMMM yyyy', locale).format(date);

  static DateTime? dateTimeFromJson(String? date) =>
      date != null && date.isNotEmpty ? DateTime.parse(date).toLocal() : null;

  static String? dateTimeToJson(DateTime? date) =>
      // ignore: prefer_null_aware_operators
      date != null ? date.toUtc().toIso8601String() : null;
}
