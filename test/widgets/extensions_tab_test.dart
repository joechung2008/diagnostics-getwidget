import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/widgets/extensions_tab.dart';

void main() {
  group('ExtensionsTab', () {
    testWidgets('displays extension list when showList is true', (
      WidgetTester tester,
    ) async {
      // Arrange
      final extensions = {
        'ext1': Extension(info: ExtensionInfo(extensionName: 'Extension 1')),
        'ext2': Extension(info: ExtensionInfo(extensionName: 'Extension 2')),
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800, // Large width to avoid small screen layout
              height: 600,
              child: ExtensionsTab(
                extensions: extensions,
                selectedExtension: null,
                onExtensionSelected: (_) {},
                showList: true,
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Extension 1'), findsOneWidget);
      expect(find.text('Extension 2'), findsOneWidget);
      // On large screens, details should show "Select an extension"
      expect(find.text('Select an extension'), findsOneWidget);
    });

    testWidgets('displays select message when no extension selected', (
      WidgetTester tester,
    ) async {
      // Arrange
      final extensions = <String, Extension>{};

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExtensionsTab(
              extensions: extensions,
              selectedExtension: null,
              onExtensionSelected: (_) {},
              showList: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Select an extension'), findsOneWidget);
    });

    testWidgets('displays extension details when selected', (
      WidgetTester tester,
    ) async {
      // Arrange
      final selectedExtension = ExtensionInfo(
        extensionName: 'Selected Extension',
      );
      final extensions = {'ext1': Extension(info: selectedExtension)};

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800, // Large width to avoid small screen layout
              height: 600,
              child: ExtensionsTab(
                extensions: extensions,
                selectedExtension: selectedExtension,
                onExtensionSelected: (_) {},
                showList: true,
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.text('Selected Extension'),
        findsNWidgets(2),
      ); // Once in list, once in details
      expect(find.text('Select an extension'), findsNothing);
    });
  });
}
