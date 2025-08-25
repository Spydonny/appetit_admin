import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetit_admin/main.dart';
import 'package:appetit_admin/core/core.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('should render complete app with theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await TestHelpers.waitForAnimations(tester);

      // Verify app structure
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should apply theme colors correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await TestHelpers.waitForAnimations(tester);

      final materialApp = TestHelpers.findWidget<MaterialApp>(tester);
      final theme = materialApp.theme;
      
      expect(theme, isNotNull);
      expect(theme!.colorScheme.primary, Colors.red);
      expect(theme.colorScheme.secondary, Colors.redAccent);
    });

    testWidgets('should have router configuration', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await TestHelpers.waitForAnimations(tester);

      final materialApp = TestHelpers.findWidget<MaterialApp>(tester);
      expect(materialApp.routerConfig, isNotNull);
    });

    testWidgets('should handle theme changes', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await TestHelpers.waitForAnimations(tester);

      // Verify theme is applied
      final materialApp = TestHelpers.findWidget<MaterialApp>(tester);
      final theme = materialApp.theme;
      
      expect(theme!.useMaterial3, true);
      expect(theme.textTheme, isA<TextTheme>());
    });
  });
}
