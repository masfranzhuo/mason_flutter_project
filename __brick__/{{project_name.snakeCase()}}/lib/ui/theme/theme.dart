import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Colors.blue;

  static ThemeData get light {
    return ThemeData(
      primarySwatch: primaryColor,
    );
  }
}
