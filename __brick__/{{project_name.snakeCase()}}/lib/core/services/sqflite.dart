import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

abstract class SqfliteService {
  Future<int> insert({
    required String table,
    required Map<String, Object?> map,
  });
  Future<List<int>> insertBulk({
    required String table,
    required List<Map<String, Object?>> maps,
  });
  Future<int> update({
    required String table,
    required Map<String, Object?> map,
  });
  Future<int> delete({required String table, required String id});
  Future<int> deleteAll({required String table});
  Future<Map<String, Object?>?> get({
    required String table,
    required String id,
    required List<String> columns,
  });
  Future<List<Map<String, Object?>>?> getList({
    required String table,
    required List<String> columns,
    String? queryColumn,
    String? query,
  });
}

@LazySingleton(as: SqfliteService)
class SqfliteServiceImpl implements SqfliteService {
  final Database database;

  SqfliteServiceImpl({required this.database});

  @override
  Future<int> insert({
    required String table,
    required Map<String, Object?> map,
  }) async {
    return await database.insert(table, map);
  }

  @override
  Future<List<int>> insertBulk({
    required String table,
    required List<Map<String, Object?>> maps,
  }) async {
    List<int> ids = [];
    await Future.forEach(maps, (Map<String, Object?> map) async {
      final id = await database.insert(table, map);
      ids.add(id);
    });

    return ids;
  }

  @override
  Future<int> update({
    required String table,
    required Map<String, Object?> map,
  }) async {
    return await database.update(
      table,
      map,
      where: 'id = ?',
      whereArgs: [map['id']],
    );
  }

  @override
  Future<int> delete({required String table, required String id}) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteAll({required String table}) async {
    return await database.delete(table);
  }

  @override
  Future<Map<String, Object?>?> get({
    required String table,
    required String id,
    required List<String> columns,
  }) async {
    final List<Map<String, Object?>> result = await database.query(
      table,
      columns: columns,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<List<Map<String, Object?>>?> getList({
    required String table,
    required List<String> columns,
    String? queryColumn,
    String? query,
  }) async {
    List<Map<String, Object?>> result;
    if ((queryColumn != null && queryColumn != '') &&
        (query != null && query != '')) {
      result = await database.query(
        table,
        columns: columns,
        where: '$queryColumn = ?',
        whereArgs: ['%$query%'],
      );
    } else {
      result = await database.query(table, columns: columns);
    }
    return result.isNotEmpty ? result : [];
  }
}
