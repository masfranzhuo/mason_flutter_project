import 'package:intl/intl.dart';

class DateConfig {
  static final DateFormat dateFormat = DateFormat('dd MMMM yyyy');

  static DateTime? dateTimeFromJson(String? date) =>
      date != null && date.isNotEmpty ? DateTime.parse(date).toLocal() : null;

  static String? dateTimeToJson(DateTime? date) =>
      // ignore: prefer_null_aware_operators
      date != null ? date.toUtc().toIso8601String() : null;
}
