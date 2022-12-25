import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:{{project_name.snakeCase()}}/core/base/exception/exception.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class InternetConnectionService {
  Future<void> checkConnection();
  Future<void> checkConnectivityState();
}

class IInternetConnectionService implements InternetConnectionService {
  IInternetConnectionService();

  final InternetConnectionChecker _internetConnectionChecker =
      InternetConnectionChecker();
  final Connectivity _connectivity = Connectivity();

  @override
  Future<void> checkConnection() async {
    try {
      bool result = await _internetConnectionChecker.hasConnection;

      if (!result) {
        throw const InternetConnectionException();
      }
    } on SocketException catch (e) {
      throw InternetConnectionException(message: e.message);
    }
  }

  @override
  Future<void> checkConnectivityState() async {
    try {
      final ConnectivityResult result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.wifi) {
        debugPrint('--- Connectivity Result: Connected to a Wi-Fi network');
        return;
      } else if (result == ConnectivityResult.mobile) {
        debugPrint('--- Connectivity Result: Connected to a mobile network');
        return;
      } else {
        debugPrint('--- Connectivity Result: Not connected to any network');
        throw const InternetConnectionException();
      }
    } on Exception catch (e) {
      throw InternetConnectionException(message: e.toString());
    }
  }
}

/// internal example implementation
///
@LazySingleton(as: InternetConnectionService)
class InternetConnectionServiceImpl extends IInternetConnectionService {}
