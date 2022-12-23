import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

abstract class LocalStorageService {
  Future<void> put(String key, dynamic value);
  Future<dynamic> get(String key);
  Future<void> delete(String key);
  Future<int> clear();
}

@LazySingleton(as: LocalStorageService)
class LocalStorageServiceImpl implements LocalStorageService {
  final Box<dynamic> hive;

  LocalStorageServiceImpl({required this.hive});

  @override
  Future<int> clear() async {
    return await hive.clear();
  }

  @override
  Future<void> delete(String key) async {
    return await hive.delete(key);
  }

  @override
  Future<dynamic> get(String key) async {
    return await hive.get(key);
  }

  @override
  Future<void> put(String key, dynamic value) async {
    await hive.put(key, value);
  }
}
