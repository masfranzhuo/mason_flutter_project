import 'dart:io';

import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:injectable/injectable.dart';

abstract class InternetConnectionService {
  Future<void> checkConnection();
}

@LazySingleton(as: InternetConnectionService)
class InternetConnectionServiceImpl implements InternetConnectionService {
  @override
  Future<void> checkConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');

      if (!response.isNotEmpty) {
        throw const InternetConnectionFailure();
      }
    } on SocketException catch (e) {
      throw InternetConnectionFailure(message: e.message);
    }
  }
}
