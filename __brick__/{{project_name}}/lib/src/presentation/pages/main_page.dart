import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:{{project_name}}.snakeCase()}}/core/utils/environment.dart';
import 'package:{{project_name}}.snakeCase()}}/src/presentation/pages/users_page/users_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPage extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;

  const MainPage({
    Key? key,
    required this.flutterI18nDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, widget) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: Environment().config.showDebugInfo,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          flutterI18nDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('id', 'ID'),
        ],
        home: const UsersPage(),
      ),
    );
  }
}
