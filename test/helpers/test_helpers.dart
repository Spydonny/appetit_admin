import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper class for common test operations
class TestHelpers {
  /// Creates a MaterialApp wrapper for testing widgets
  static Widget createTestApp({
    required Widget child,
    ThemeData? theme,
    List<NavigatorObserver>? navigatorObservers,
  }) {
    return MaterialApp(
      home: child,
      theme: theme,
      navigatorObservers: navigatorObservers ?? [],
    );
  }

  /// Creates a Scaffold wrapper for testing widgets
  static Widget createTestScaffold({
    required Widget child,
    PreferredSizeWidget? appBar,
    Widget? drawer,
  }) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: child,
    );
  }

  /// Waits for animations to complete
  static Future<void> waitForAnimations(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Finds a widget by type and verifies it exists
  static T findWidget<T extends Widget>(WidgetTester tester) {
    return tester.widget<T>(find.byType(T));
  }

  /// Finds text and verifies it exists
  static Finder findText(String text) {
    return find.text(text);
  }

  /// Finds a widget by key and verifies it exists
  static Finder findWidgetByKey(Key key) {
    return find.byKey(key);
  }

  /// Taps on a widget and waits for the frame
  static Future<void> tapWidget(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  /// Enters text into a text field
  static Future<void> enterText(WidgetTester tester, Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Scrolls to find a widget
  static Future<void> scrollToFind(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 500.0);
    await tester.pump();
  }
}

/// Mock navigator observer for testing navigation
class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];
  final List<Route<dynamic>> poppedRoutes = [];
  final List<Route<dynamic>> removedRoutes = [];
  final List<Route<dynamic>> replacedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    poppedRoutes.add(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    removedRoutes.add(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      replacedRoutes.add(newRoute);
    }
  }

  void reset() {
    pushedRoutes.clear();
    poppedRoutes.clear();
    removedRoutes.clear();
    replacedRoutes.clear();
  }
}
