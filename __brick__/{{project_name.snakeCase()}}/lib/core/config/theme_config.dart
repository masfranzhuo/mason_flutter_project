import 'package:flutter/material.dart';

class ThemeConfig {
  static const primaryColor = Colors.blue;

  static ThemeData get light {
    return ThemeData(
      primarySwatch: primaryColor,
    );
  }
}
