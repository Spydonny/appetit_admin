import 'package:flutter_test/flutter_test.dart';
import 'package:appetit_admin/core/router/auth_state.dart';

void main() {
  group('AuthState Tests', () {
    late AuthState authState;

    setUp(() {
      authState = AuthState();
    });

    test('should initialize with no token', () {
      expect(authState.isLoggedIn, false);
    });

    test('should login with token', () {
      const token = 'test_token_123';
      authState.login(token);
      expect(authState.isLoggedIn, true);
    });

    test('should logout and clear token', () {
      // First login
      authState.login('test_token');
      expect(authState.isLoggedIn, true);

      // Then logout
      authState.logout();
      expect(authState.isLoggedIn, false);
    });

    test('should validate token successfully when logged in', () async {
      authState.login('valid_token');
      final isValid = await authState.validateToken();
      expect(isValid, true);
    });

    test('should fail token validation when not logged in', () async {
      final isValid = await authState.validateToken();
      expect(isValid, false);
    });

    test('should fail token validation with empty token', () async {
      authState.login('');
      final isValid = await authState.validateToken();
      expect(isValid, false);
    });

    test('should notify listeners on login', () {
      var notificationCount = 0;
      authState.addListener(() {
        notificationCount++;
      });

      authState.login('token');
      expect(notificationCount, 1);
    });

    test('should notify listeners on logout', () {
      authState.login('token');
      
      var notificationCount = 0;
      authState.addListener(() {
        notificationCount++;
      });

      authState.logout();
      expect(notificationCount, 1);
    });
  });
}
