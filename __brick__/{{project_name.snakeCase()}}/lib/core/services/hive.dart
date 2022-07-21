import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

abstract class HiveService {
  void put(String key, String value);
  String get(String key);
  Future<void> delete(String key);
  Future<int> clear();
}

@LazySingleton(as: HiveService)
class HiveServiceImpl implements HiveService {
  final Box<dynamic> hive;

  HiveServiceImpl({required this.hive});

  @override
  Future<int> clear() async {
    return await hive.clear();
  }

  @override
  Future<void> delete(String key) async {
    return await hive.delete(key);
  }

  @override
  String get(String key) {
    return hive.get(key);
  }

  @override
  void put(String key, String value) {
    hive.put(key, value);
  }
}
