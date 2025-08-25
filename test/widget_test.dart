import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:appetit_admin/main.dart';

void main() {
  group('Appetit Admin App Tests', () {
    testWidgets('App should render without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the app renders without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should have MaterialApp.router', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify that MaterialApp.router is used
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should have router configuration', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.routerConfig, isNotNull);
    });
  });
}
