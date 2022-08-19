import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:injectable/injectable.dart';

abstract class InternetConnectionService {
  Future<void> checkConnection();
  Future<void> checkConnectivityState();
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

  @override
  Future<void> checkConnectivityState() async {
    try {
      final ConnectivityResult result =
          await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.wifi) {
        debugPrint('--- Connectivity Result: Connected to a Wi-Fi network');
        return;
      } else if (result == ConnectivityResult.mobile) {
        debugPrint('--- Connectivity Result: Connected to a mobile network');
        return;
      } else {
        debugPrint('--- Connectivity Result: Not connected to any network');
        throw const InternetConnectionFailure();
      }
    } on Exception catch (e) {
      throw InternetConnectionFailure(message: e.toString());
    }
  }
}
