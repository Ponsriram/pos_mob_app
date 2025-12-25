import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Primary seed color used in the app
  static const Color _seedColor = Color.fromARGB(255, 18, 144, 255);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
      brightness: Brightness.light,
    ),
    // fontFamily: 'Poppins',
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
      brightness: Brightness.dark,
    ),
    // fontFamily: 'Poppins',
  );
}
