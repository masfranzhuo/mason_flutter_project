import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class LocalStorageService {
  Future<void> put(String key, dynamic value);
  Future<dynamic> get(String key);
  Future<void> delete(String key);
  Future<int> clear();
}

class ILocalStorageService implements LocalStorageService {
  static const String _dbName = 'db';
  final Box<dynamic> _hive;

  ILocalStorageService() : _hive = Hive.box(_dbName);

  /// call or initialize this before run app
  ///
  static init() async {
    await Hive.initFlutter();
    await Hive.openBox(_dbName);
  }

  @override
  Future<int> clear() async {
    return await _hive.clear();
  }

  @override
  Future<void> delete(String key) async {
    return await _hive.delete(key);
  }

  @override
  Future<dynamic> get(String key) async {
    return await _hive.get(key);
  }

  @override
  Future<void> put(String key, dynamic value) async {
    await _hive.put(key, value);
  }
}

/// internal example implementation
///
@LazySingleton(as: LocalStorageService)
class LocalStoageServiceImpl extends ILocalStorageService {}
