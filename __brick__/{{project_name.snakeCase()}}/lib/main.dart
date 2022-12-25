import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:{{project_name.snakeCase()}}/core/config/base_config.dart';
import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/core/services/services.dart';
import 'package:{{project_name.snakeCase()}}/ui/theme/theme.dart';
import 'package:{{project_name.snakeCase()}}/core/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: AppTheme.primaryColor),
  );

  await ILocalStorageService.init();
  await configureDependencies(EnvConfig.environment);
  await dotenv.load(fileName: GetIt.I<BaseConfig>().envFileName);

  runApp(
    DevicePreview(
      enabled: (Platform.isAndroid || Platform.isIOS)
          ? false
          : GetIt.I<BaseConfig>().showDebugInfo,
      builder: (context) => EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('id', 'ID'),
        ],
        fallbackLocale: const Locale('en', 'US'),
        path: 'assets/i18n',
        child: App(),
      ),
    ),
  );
}
