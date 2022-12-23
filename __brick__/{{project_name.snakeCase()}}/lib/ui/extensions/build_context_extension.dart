import 'package:flutter/widgets.dart';
import 'package:flutter_project/core/services/translator.dart';
import 'package:get_it/get_it.dart';

extension BuildContextExtension on BuildContext {
  String translate(
    String key, {
    String? fallbackKey,
    Map<String, String>? translationParams,
  }) =>
      GetIt.I<TranslatorService>().translate(this, key);
}
