import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appetit_admin/widgets/buttons/pill_button.dart';

void main() {
  group('PillButton Tests', () {
    testWidgets('should render with default theme colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () {},
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should render with custom colors', (WidgetTester tester) async {
      const customColor = Colors.blue;
      const customOnColor = Colors.white;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () {},
              colorPrimary: customColor,
              colorOnPrimary: customOnColor,
              child: const Text('Custom Button'),
            ),
          ),
        ),
      );

      expect(find.text('Custom Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      var buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () {
                buttonPressed = true;
              },
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PillButton));
      expect(buttonPressed, true);
    });

    testWidgets('should not call onPressed when disabled', (WidgetTester tester) async {
      var buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: null, // Disabled button
              child: const Text('Disabled Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PillButton));
      expect(buttonPressed, false);
    });

    testWidgets('should have correct button dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () {},
              child: const Text('Size Test'),
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style;

      // Check if the button has the correct fixed size
      expect(buttonStyle?.fixedSize?.resolve({}), const Size.fromHeight(56));
    });

    testWidgets('should have rounded corners', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () {},
              child: const Text('Rounded Button'),
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style;
      final shape = buttonStyle?.shape?.resolve({});

      expect(shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('should have no elevation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PillButton(
              onPressed: () {},
              child: const Text('Flat Button'),
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style;
      final elevation = buttonStyle?.elevation?.resolve({});

      expect(elevation, 0);
    });
  });
}
