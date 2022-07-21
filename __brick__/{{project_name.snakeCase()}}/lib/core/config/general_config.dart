class Pagination {
  static const limit = 10;
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
