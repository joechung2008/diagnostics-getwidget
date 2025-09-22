import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getwidget/getwidget.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/widgets/dashboard_app_bar.dart';

void main() {
  group('DashboardAppBar', () {
    late Environment testEnvironment;
    late Map<String, Extension> testExtensions;

    setUp(() {
      testEnvironment = Environment.public;
      testExtensions = {
        'test-extension': Extension(
          info: ExtensionInfo(extensionName: 'Test Extension'),
        ),
        'paasserverless': Extension(
          info: ExtensionInfo(extensionName: 'PaaS Serverless'),
        ),
        'websites': Extension(info: ExtensionInfo(extensionName: 'Websites')),
      };
    });

    testWidgets('displays selected environment display name as title', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: DashboardAppBar(
              selectedEnvironment: testEnvironment,
              showExtensionsList: true,
              currentTabIndex: 0,
              extensions: testExtensions,
              onToggleExtensionsList: () {},
              onShortcutPressed: (_) {},
              onEnvironmentChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Public Cloud'), findsOneWidget);
    });

    testWidgets('displays menu button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: DashboardAppBar(
              selectedEnvironment: testEnvironment,
              showExtensionsList: true,
              currentTabIndex: 0,
              extensions: testExtensions,
              onToggleExtensionsList: () {},
              onShortcutPressed: (_) {},
              onEnvironmentChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets(
      'shows leading icon button when tab index is 0 and screen width <= 600',
      (WidgetTester tester) async {
        // Arrange
        tester.view.physicalSize = const Size(600, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: DashboardAppBar(
                selectedEnvironment: testEnvironment,
                showExtensionsList: true,
                currentTabIndex: 0,
                extensions: testExtensions,
                onToggleExtensionsList: () {},
                onShortcutPressed: (_) {},
                onEnvironmentChanged: (_) {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(GFIconButton), findsOneWidget);
      },
    );

    testWidgets('does not show leading icon button when tab index is not 0', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: DashboardAppBar(
              selectedEnvironment: testEnvironment,
              showExtensionsList: true,
              currentTabIndex: 1, // Not 0
              extensions: testExtensions,
              onToggleExtensionsList: () {},
              onShortcutPressed: (_) {},
              onEnvironmentChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(GFIconButton), findsNothing);
    });

    testWidgets(
      'calls onToggleExtensionsList when leading icon button is tapped',
      (WidgetTester tester) async {
        // Arrange
        tester.view.physicalSize = const Size(600, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        bool callbackCalled = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: DashboardAppBar(
                selectedEnvironment: testEnvironment,
                showExtensionsList: true,
                currentTabIndex: 0,
                extensions: testExtensions,
                onToggleExtensionsList: () => callbackCalled = true,
                onShortcutPressed: (_) {},
                onEnvironmentChanged: (_) {},
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(GFIconButton));
        await tester.pump();

        // Assert
        expect(callbackCalled, isTrue);
      },
    );

    testWidgets('shows environment options and shortcuts in menu', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: DashboardAppBar(
              selectedEnvironment: testEnvironment,
              showExtensionsList: true,
              currentTabIndex: 0,
              extensions: testExtensions,
              onToggleExtensionsList: () {},
              onShortcutPressed: (_) {},
              onEnvironmentChanged: (_) {},
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();

      // Assert - Check that menu items are in the widget tree (they may not be hittable in test)
      expect(find.text('Fairfax'), findsOneWidget);
      expect(find.text('Mooncake'), findsOneWidget);
      expect(find.text('paasserverless'), findsOneWidget);
      expect(find.text('websites'), findsOneWidget);
    });

    testWidgets('shows paasserverless option when extension exists', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: DashboardAppBar(
              selectedEnvironment: testEnvironment,
              showExtensionsList: true,
              currentTabIndex: 0,
              extensions: testExtensions,
              onToggleExtensionsList: () {},
              onShortcutPressed: (_) {},
              onEnvironmentChanged: (_) {},
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();

      // Assert
      expect(find.text('paasserverless'), findsOneWidget);
    });

    testWidgets(
      'does not show paasserverless option when extension does not exist',
      (WidgetTester tester) async {
        // Arrange
        final extensionsWithoutPaas = {
          'test-extension': Extension(
            info: ExtensionInfo(extensionName: 'Test Extension'),
          ),
        };

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: DashboardAppBar(
                selectedEnvironment: testEnvironment,
                showExtensionsList: true,
                currentTabIndex: 0,
                extensions: extensionsWithoutPaas,
                onToggleExtensionsList: () {},
                onShortcutPressed: (_) {},
                onEnvironmentChanged: (_) {},
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pump();

        // Assert
        expect(find.text('paasserverless'), findsNothing);
      },
    );

    testWidgets('has correct preferred size', (WidgetTester tester) async {
      // Arrange
      final appBar = DashboardAppBar(
        selectedEnvironment: testEnvironment,
        showExtensionsList: true,
        currentTabIndex: 0,
        extensions: testExtensions,
        onToggleExtensionsList: () {},
        onShortcutPressed: (_) {},
        onEnvironmentChanged: (_) {},
      );

      // Assert
      expect(
        appBar.preferredSize,
        equals(const Size.fromHeight(kToolbarHeight)),
      );
    });
  });
}
