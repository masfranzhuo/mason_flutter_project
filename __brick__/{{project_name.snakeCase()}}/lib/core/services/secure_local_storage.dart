import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// https://github.com/mogol/flutter_secure_storage/issues/345
///

const credMaxCredentialBlobSize = 5 * 512;

abstract class SecureLocalStorageService {
  Future<void> put(String key, dynamic value);
  Future<dynamic> get(String key);
  Future<Map<String, dynamic>> fetch();
  Future<void> delete(String key);
  Future<void> clear();
}

@LazySingleton(as: SecureLocalStorageService)
class SecureLocalStorageServiceImpl implements SecureLocalStorageService {
  final FlutterSecureStorage storage;

  SecureLocalStorageServiceImpl(this.storage);

  @override
  Future<void> delete(String key) async {
    if (Platform.isWindows) {
      final chunkedKey = '\$${key}_chunk_size';

      final chunkSize = int.parse(await storage.read(key: chunkedKey) ?? '0');

      if (chunkSize > 0) {
        await Future.wait(List.generate(chunkSize,
            (i) async => await storage.delete(key: '${key}_${i + 1}')));
      } else {
        await storage.delete(key: key);
      }
    } else {
      await storage.delete(key: key);
    }
  }

  @override
  Future<void> clear() async {
    await storage.deleteAll();
  }

  @override
  Future<dynamic> get(String key) async {
    if (Platform.isWindows) {
      final chunkedKey = '\$${key}_chunk_size';

      final chunkSize = int.parse(await storage.read(key: chunkedKey) ?? '0');

      if (chunkSize > 0) {
        final chunks = await Future.wait(List.generate(chunkSize,
            (i) async => await storage.read(key: '${key}_${i + 1}')));
        return chunks.join();
      } else {
        return await storage.read(key: key);
      }
    } else {
      return await storage.read(key: key);
    }
  }

  @override
  Future<Map<String, String>> fetch() async {
    return await storage.readAll();
  }

  @override
  Future<void> put(String key, dynamic value) async {
    if (Platform.isWindows && value.length > credMaxCredentialBlobSize) {
      final exp = RegExp(r'.{1,512}');
      final matches = exp.allMatches(value).toList();
      final chunkedKey = '\$${key}_chunk_size';
      await Future.wait(List.generate(matches.length + 1, (i) {
        return i == 0
            ? storage.write(key: chunkedKey, value: matches.length.toString())
            : storage.write(key: '${key}_$i', value: matches[i - 1].group(0));
      }));
    } else {
      await storage.write(key: key, value: value);
    }
  }
}
