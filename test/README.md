# Appetit Admin - Test Suite

This directory contains comprehensive tests for the Appetit Admin Flutter application.

## Test Structure

```
test/
├── README.md                    # This file
├── run_tests.dart              # Test runner script
├── test_config.dart            # Test configuration and constants
├── widget_test.dart            # Main widget tests
├── helpers/
│   └── test_helpers.dart       # Common test utilities and helpers
├── core/
│   ├── router/
│   │   ├── auth_state_test.dart    # Authentication state tests
│   │   └── router_test.dart        # Router configuration tests
│   └── theme/
│       └── app_theme_test.dart     # Theme configuration tests
├── widgets/
│   └── buttons/
│       └── pill_button_test.dart   # Pill button widget tests
└── integration/
    └── app_integration_test.dart   # App integration tests
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/core/router/auth_state_test.dart
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Run tests with verbose output
```bash
flutter test --verbose
```

## Test Categories

### 1. Unit Tests
- **AuthState**: Tests authentication logic, login/logout, token validation
- **AppTheme**: Tests theme configuration and color schemes
- **Router**: Tests routing configuration and route definitions

### 2. Widget Tests
- **PillButton**: Tests button rendering, interactions, and styling
- **Main App**: Tests app initialization and basic structure

### 3. Integration Tests
- **App Integration**: Tests overall app behavior and theme application

## Test Helpers

The `test_helpers.dart` file provides common utilities:
- `TestHelpers.createTestApp()`: Creates MaterialApp wrapper for testing
- `TestHelpers.createTestScaffold()`: Creates Scaffold wrapper for testing
- `TestHelpers.waitForAnimations()`: Waits for animations to complete
- `TestHelpers.findWidget()`: Finds widgets by type
- `TestHelpers.tapWidget()`: Taps on widgets and waits for frame
- `TestHelpers.enterText()`: Enters text into text fields

## Test Configuration

The `test_config.dart` file contains:
- Test timeouts and durations
- Test data constants
- Common test data structures
- Validation regex patterns

## Writing New Tests

When adding new tests:

1. **Follow the existing structure**: Place tests in appropriate directories
2. **Use test helpers**: Leverage the provided test utilities
3. **Group related tests**: Use `group()` for organizing related test cases
4. **Test both success and failure cases**: Cover edge cases and error conditions
5. **Use descriptive test names**: Make test names clear and descriptive
6. **Add to test runner**: Include new test files in `run_tests.dart`

## Example Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:appetit_admin/your_feature/your_widget.dart';

void main() {
  group('YourWidget Tests', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(YourWidget());
      expect(find.byType(YourWidget), findsOneWidget);
    });

    testWidgets('should handle user interaction', (WidgetTester tester) async {
      // Test implementation
    });
  });
}
```

## Best Practices

1. **Test isolation**: Each test should be independent
2. **Clean setup/teardown**: Use `setUp()` and `tearDown()` methods
3. **Meaningful assertions**: Test behavior, not implementation details
4. **Async testing**: Properly handle async operations with `await`
5. **Mock external dependencies**: Use mocks for API calls and external services
6. **Test coverage**: Aim for high test coverage of critical paths

## Troubleshooting

### Common Issues

1. **Test timeout**: Increase timeout in `test_config.dart`
2. **Widget not found**: Use `pumpAndSettle()` for animations
3. **State not updated**: Ensure proper `await` usage
4. **Import errors**: Check file paths and import statements

### Debug Mode

Run tests in debug mode for more detailed output:
```bash
flutter test --verbose --reporter=expanded
```
