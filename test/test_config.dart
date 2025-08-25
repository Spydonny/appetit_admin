import 'package:flutter_test/flutter_test.dart';

/// Test configuration and setup
class TestConfig {
  /// Default timeout for async operations
  static const Duration defaultTimeout = Duration(seconds: 30);
  
  /// Default pump duration for animations
  static const Duration defaultPumpDuration = Duration(milliseconds: 100);
  
  /// Test data constants
  static const String testToken = 'test_token_12345';
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'test_password_123';
  
  /// Test user data
  static const Map<String, dynamic> testUser = {
    'id': 'user_123',
    'email': 'test@example.com',
    'name': 'Test User',
    'role': 'admin',
  };
  
  /// Test order data
  static const Map<String, dynamic> testOrder = {
    'id': 'order_123',
    'customerName': 'John Doe',
    'total': 29.99,
    'status': 'pending',
    'items': [
      {'name': 'Pizza Margherita', 'quantity': 2, 'price': 14.99},
    ],
  };
  
  /// Test menu item data
  static const Map<String, dynamic> testMenuItem = {
    'id': 'item_123',
    'name': 'Test Item',
    'description': 'A test menu item',
    'price': 9.99,
    'category': 'main',
    'available': true,
  };
  
  /// Test analytics data
  static const Map<String, dynamic> testAnalytics = {
    'totalOrders': 150,
    'totalRevenue': 2999.99,
    'averageOrderValue': 19.99,
    'topSellingItems': [
      {'name': 'Pizza Margherita', 'sales': 45},
      {'name': 'Caesar Salad', 'sales': 32},
    ],
  };
  
  /// Test marketing data
  static const Map<String, dynamic> testMarketing = {
    'campaigns': [
      {'id': 'camp_1', 'name': 'Summer Sale', 'status': 'active'},
      {'id': 'camp_2', 'name': 'Holiday Special', 'status': 'draft'},
    ],
    'totalCustomers': 1250,
    'emailSubscribers': 890,
  };
}

/// Test matchers for common assertions
class TestMatchers {
  /// Matches a valid email format
  static final RegExp validEmail = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  
  /// Matches a valid phone number format
  static final RegExp validPhone = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
  
  /// Matches a valid price format (positive number with up to 2 decimal places)
  static final RegExp validPrice = RegExp(
    r'^\d+(\.\d{1,2})?$',
  );
}
