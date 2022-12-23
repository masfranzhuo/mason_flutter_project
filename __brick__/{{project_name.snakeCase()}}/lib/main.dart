import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/core/config/base_config.dart';
import 'package:flutter_project/core/config/general_config.dart';
import 'package:flutter_project/generated/codegen_loader.g.dart';
import 'package:flutter_project/ui/theme/theme.dart';
import 'package:flutter_project/core/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project/app/app.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: AppTheme.primaryColor),
  );

  await Hive.initFlutter();
  await Hive.openBox('box');
  await configureDependencies(EnvConfig.environment);
  await dotenv.load(fileName: GetIt.I<BaseConfig>().envFileName);

  runApp(
    DevicePreview(
      enabled: GetIt.I<BaseConfig>().showDebugInfo,
      builder: (context) => EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('id', 'ID'),
        ],
        fallbackLocale: const Locale('en', 'US'),
        path: 'assets/i18n',
        assetLoader: const CodegenLoader(),
        child: App(),
      ),
    ),
  );
}
