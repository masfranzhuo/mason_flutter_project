import 'package:drift/drift.dart';
import 'package:{{project_name.snakeCase()}}/features/users/database/utils/converters.dart';

class UserDrift extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get picture => text()();
  TextColumn get dateOfBirth => text().nullable()();
  TextColumn get registerDate => text().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get location => text().map(const MapConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
