import 'package:flutter/material.dart';
import 'calligraphy.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.from(
    colorScheme: const ColorScheme.light(
      primary: Colors.red,
      secondary: Colors.redAccent,
    ),
    textTheme: Calligraphy.textTheme,
    useMaterial3: true,
  );

}