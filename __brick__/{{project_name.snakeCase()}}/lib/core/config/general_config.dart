import 'package:injectable/injectable.dart';

class EnvConfig {
  static const environment = String.fromEnvironment(
    'ENV',
    defaultValue: Environment.dev,
  );
}

class PaginationConfig {
  static const limit = 10;
}

class DateConfig {
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
