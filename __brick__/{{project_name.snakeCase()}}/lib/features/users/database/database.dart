import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:{{project_name.snakeCase()}}/features/users/database/schemas/user_drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:{{project_name.snakeCase()}}/features/users/database/utils/converters.dart';

part 'database.g.dart';

@DriftDatabase(tables: [UserDrift])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
