import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getwidget/getwidget.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/widgets/dashboard_body.dart';

void main() {
  group('DashboardBody', () {
    testWidgets('shows loading indicator when isLoading is true', (
      WidgetTester tester,
    ) async {
      // Arrange
      final state = const DashboardState(isLoading: true);
      final tabController = TabController(length: 3, vsync: tester);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardBody(
              state: state,
              tabController: tabController,
              onEnvironmentChanged: (_) {},
              onExtensionSelected: (_) {},
              onShortcutPressed: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when error is not null', (
      WidgetTester tester,
    ) async {
      // Arrange
      final state = const DashboardState(error: 'Test error');
      final tabController = TabController(length: 3, vsync: tester);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardBody(
              state: state,
              tabController: tabController,
              onEnvironmentChanged: (_) {},
              onExtensionSelected: (_) {},
              onShortcutPressed: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Error: Test error'), findsOneWidget);
    });

    testWidgets('shows no data message when diagnostics is null', (
      WidgetTester tester,
    ) async {
      // Arrange
      final state = const DashboardState();
      final tabController = TabController(length: 3, vsync: tester);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardBody(
              state: state,
              tabController: tabController,
              onEnvironmentChanged: (_) {},
              onExtensionSelected: (_) {},
              onShortcutPressed: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('No data'), findsOneWidget);
    });

    testWidgets('shows tabs and content when diagnostics is available', (
      WidgetTester tester,
    ) async {
      // Arrange
      final diagnostics = Diagnostics(
        buildInfo: BuildInfo(buildVersion: '1.0.0'),
        extensions: {},
        serverInfo: ServerInfo(
          hostname: 'test',
          deploymentId: 'test',
          serverId: 'test',
          nodeVersions: 'v18',
          uptime: 1000,
          extensionSync: ExtensionSync(totalSyncAllCount: 0),
        ),
      );
      final state = DashboardState(diagnostics: diagnostics);
      final tabController = TabController(length: 3, vsync: tester);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardBody(
              state: state,
              tabController: tabController,
              onEnvironmentChanged: (_) {},
              onExtensionSelected: (_) {},
              onShortcutPressed: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(GFTabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
      expect(find.text('Extensions'), findsOneWidget);
      expect(find.text('Build Info'), findsOneWidget);
      expect(find.text('Server Info'), findsOneWidget);
    });
  });
}
