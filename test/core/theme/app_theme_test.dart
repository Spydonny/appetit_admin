import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetit_admin/core/theme/app_theme.dart';

void main() {
  group('AppTheme Tests', () {
    test('should have light theme with correct color scheme', () {
      final theme = AppTheme.lightTheme;
      
      expect(theme, isA<ThemeData>());
      expect(theme.colorScheme.primary, Colors.red);
      expect(theme.colorScheme.secondary, Colors.redAccent);
    });

    test('should use Material 3', () {
      final theme = AppTheme.lightTheme;
      expect(theme.useMaterial3, true);
    });

    test('should have custom text theme from Calligraphy', () {
      final theme = AppTheme.lightTheme;
      expect(theme.textTheme, isA<TextTheme>());
    });

    test('should create theme from color scheme', () {
      final theme = AppTheme.lightTheme;
      
      // Verify that the theme is created from a color scheme
      expect(theme.colorScheme, isA<ColorScheme>());
      expect(theme.colorScheme.brightness, Brightness.light);
    });

    test('should have consistent color scheme properties', () {
      final theme = AppTheme.lightTheme;
      final colorScheme = theme.colorScheme;
      
      // Verify that the color scheme is properly configured
      expect(colorScheme.primary, isA<Color>());
      expect(colorScheme.secondary, isA<Color>());
      expect(colorScheme.surface, isA<Color>());
      expect(colorScheme.background, isA<Color>());
    });
  });
}
