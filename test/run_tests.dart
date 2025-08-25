import 'package:flutter_test/flutter_test.dart';

import 'widget_test.dart' as widget_test;
import 'core/router/auth_state_test.dart' as auth_state_test;
import 'core/router/router_test.dart' as router_test;
import 'core/theme/app_theme_test.dart' as app_theme_test;
import 'widgets/buttons/pill_button_test.dart' as pill_button_test;
import 'integration/app_integration_test.dart' as app_integration_test;

void main() {
  group('Running All Tests', () {
    test('Widget Tests', () {
      widget_test.main();
    });

    test('Auth State Tests', () {
      auth_state_test.main();
    });

    test('Router Tests', () {
      router_test.main();
    });

    test('App Theme Tests', () {
      app_theme_test.main();
    });

    test('Pill Button Tests', () {
      pill_button_test.main();
    });

    test('App Integration Tests', () {
      app_integration_test.main();
    });
  });
}
