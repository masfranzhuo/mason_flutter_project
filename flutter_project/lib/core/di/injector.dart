import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_project/core/di/injector.config.dart';

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() => $initGetIt(GetIt.instance);
