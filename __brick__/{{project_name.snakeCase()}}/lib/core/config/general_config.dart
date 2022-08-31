import 'package:intl/intl.dart';

class PaginationConfig {
  static const limit = 10;
}

class NumberConfig {
  static String format(double number, [String locale = 'en_US']) =>
      NumberFormat('#,##0', locale).format(number);

  static String currencyFormat(
    double number, [
    String prefix = '\$',
    String locale = 'en_US',
  ]) =>
      '$prefix${NumberFormat('#,##0', locale).format(number)}';
}

class DateConfig {
  static String dateFormat(DateTime date, [String locale = 'en_US']) =>
      DateFormat('dd MMMM yyyy', locale).format(date.toLocal());

  static String dateTimeFormat(DateTime date, [String locale = 'en_US']) =>
      DateFormat('dd MMMM yyyy, HH:mm', locale).format(date.toLocal());

  static String dateTimeNameFormat(DateTime date, [String locale = 'en_US']) =>
      DateFormat('EEEE,dd MMMM yyyy, HH:mm', locale).format(date.toLocal());

  static DateTime? dateTimeFromJson(String? date) =>
      date != null && date.isNotEmpty ? DateTime.parse(date).toLocal() : null;

  static String? dateTimeToJson(DateTime? date) =>
      // ignore: prefer_null_aware_operators
      date != null ? date.toUtc().toIso8601String() : null;
}

class DatabaseSql {
  static const createTableUser = '''
    CREATE TABLE IF NOT EXISTS User (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      firstName TEXT NOT NULL,
      lastName TEXT NOT NULL,
      picture TEXT NOT NULL,
      gender TEXT,
      email TEXT,
      phone TEXT,
      dateOfBirth TEXT,
      registerDate TEXT,
      location TEXT
    )
  ''';
}
