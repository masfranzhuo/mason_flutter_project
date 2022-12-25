import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injectable/injectable.dart';

abstract class TranslatorService {
  String translate(
    final BuildContext context,
    final String key, {
    final String? fallbackKey,
    final Map<String, String>? translationParams,
  });
  String plural(
    final BuildContext context,
    final String key,
    final int pluralValue,
  );
}

@LazySingleton(as: TranslatorService)
class TranslatorServiceImpl implements TranslatorService {
  @override
  String translate(
    BuildContext context,
    String key, {
    String? fallbackKey,
    Map<String, String>? translationParams,
  }) {
    return FlutterI18n.translate(
      context,
      key,
      fallbackKey: fallbackKey,
      translationParams: translationParams,
    );
  }

  @override
  String plural(BuildContext context, String key, int pluralValue) {
    return FlutterI18n.plural(context, key, pluralValue);
  }
}
