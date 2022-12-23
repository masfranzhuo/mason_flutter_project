import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/core/config/base_config.dart';
import 'package:flutter_project/core/route/route.dart';
import 'package:flutter_project/ui/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class App extends StatelessWidget {
  final _router = AppRoute.router();

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, widget) => MaterialApp.router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: GetIt.I<BaseConfig>().appName,
        debugShowCheckedModeBanner: GetIt.I<BaseConfig>().showDebugInfo,
        theme: AppTheme.light,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
