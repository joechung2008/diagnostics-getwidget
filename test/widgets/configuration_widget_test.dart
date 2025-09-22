import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/widgets/configuration_widget.dart';

void main() {
  group('ConfigurationWidget', () {
    testWidgets('displays configuration data in a table', (
      WidgetTester tester,
    ) async {
      // Arrange
      final config = Configuration(
        config: {'key1': 'value1', 'key2': 'value2'},
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ConfigurationWidget(config: config)),
        ),
      );

      // Assert
      expect(find.text('Configuration'), findsOneWidget);
      expect(find.text('Key'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('key1'), findsOneWidget);
      expect(find.text('value1'), findsOneWidget);
      expect(find.text('key2'), findsOneWidget);
      expect(find.text('value2'), findsOneWidget);
    });

    testWidgets('displays empty configuration', (WidgetTester tester) async {
      // Arrange
      final config = Configuration(config: {});

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ConfigurationWidget(config: config)),
        ),
      );

      // Assert
      expect(find.text('Configuration'), findsOneWidget);
      expect(find.text('Key'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      // No data rows should be present
      expect(find.text('key1'), findsNothing);
    });
  });
}
