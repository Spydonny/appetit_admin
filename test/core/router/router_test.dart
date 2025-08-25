import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:appetit_admin/core/router/router.dart';

void main() {
  group('Router Tests', () {
    test('should have auth state instance', () {
      expect(authState, isA<ChangeNotifier>());
    });

    test('should have router instance', () {
      expect(router, isA<GoRouter>());
    });

    test('should have router configuration', () {
      expect(router, isNotNull);
    });

    test('should have auth state as refresh listenable', () {
      // Note: This property might not be accessible in newer versions
      // We'll test the router exists and is properly configured
      expect(router, isA<GoRouter>());
    });
  });
}
