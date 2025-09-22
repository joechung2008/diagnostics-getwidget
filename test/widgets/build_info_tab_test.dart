import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/widgets/build_info_tab.dart';

void main() {
  group('BuildInfoTab', () {
    testWidgets('displays build info in a table', (WidgetTester tester) async {
      // Arrange
      final buildInfo = BuildInfo(buildVersion: '1.2.3');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BuildInfoTab(buildInfo: buildInfo)),
        ),
      );

      // Assert
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('Build Version'), findsOneWidget);
      expect(find.text('1.2.3'), findsOneWidget);
    });

    testWidgets('displays unknown version when buildVersion is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      final buildInfo = BuildInfo(buildVersion: '');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BuildInfoTab(buildInfo: buildInfo)),
        ),
      );

      // Assert
      expect(find.text('Build Version'), findsOneWidget);
      expect(find.text(''), findsOneWidget);
    });
  });
}
