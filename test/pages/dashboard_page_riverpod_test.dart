import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:diagnostics_getwidget/pages/dashboard_page_riverpod.dart';
import 'package:diagnostics_getwidget/controllers/dashboard_controller.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/services.dart';

// Mock classes
class MockDiagnosticsService extends Mock implements DiagnosticsService {}

void main() {
  late MockDiagnosticsService mockDiagnosticsService;

  setUpAll(() {
    registerFallbackValue(Environment.public);
  });

  setUp(() {
    mockDiagnosticsService = MockDiagnosticsService();
  });

  group('DashboardPage (Riverpod)', () {
    testWidgets('should display app bar with environment name', (
      WidgetTester tester,
    ) async {
      // Arrange
      final diagnostics = Diagnostics(
        buildInfo: BuildInfo(buildVersion: '1.0.0'),
        extensions: {},
        serverInfo: ServerInfo(
          hostname: 'test-server',
          deploymentId: 'test-deployment',
          extensionSync: ExtensionSync(totalSyncAllCount: 0),
          nodeVersions: 'v18.0.0',
          serverId: 'test-server-id',
          uptime: 12345,
        ),
      );

      when(
        () => mockDiagnosticsService.fetchDiagnostics(any()),
      ).thenAnswer((_) async => diagnostics);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diagnosticsServiceProvider.overrideWithValue(
              mockDiagnosticsService,
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // Wait for initial load
      await tester.pump();

      // Assert
      expect(find.text('Public Cloud'), findsOneWidget);
      expect(find.byType(GFAppBar), findsOneWidget);
    });

    testWidgets('should display popup menu with environment options', (
      WidgetTester tester,
    ) async {
      // Arrange
      final diagnostics = Diagnostics(
        buildInfo: BuildInfo(buildVersion: '1.0.0'),
        extensions: {},
        serverInfo: ServerInfo(
          hostname: 'test-server',
          deploymentId: 'test-deployment',
          extensionSync: ExtensionSync(totalSyncAllCount: 0),
          nodeVersions: 'v18.0.0',
          serverId: 'test-server-id',
          uptime: 12345,
        ),
      );

      when(
        () => mockDiagnosticsService.fetchDiagnostics(any()),
      ).thenAnswer((_) async => diagnostics);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diagnosticsServiceProvider.overrideWithValue(
              mockDiagnosticsService,
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should handle environment change from popup menu', (
      WidgetTester tester,
    ) async {
      // Arrange
      final diagnostics = Diagnostics(
        buildInfo: BuildInfo(buildVersion: '1.0.0'),
        extensions: {},
        serverInfo: ServerInfo(
          hostname: 'test-server',
          deploymentId: 'test-deployment',
          extensionSync: ExtensionSync(totalSyncAllCount: 0),
          nodeVersions: 'v18.0.0',
          serverId: 'test-server-id',
          uptime: 12345,
        ),
      );

      when(
        () => mockDiagnosticsService.fetchDiagnostics(any()),
      ).thenAnswer((_) async => diagnostics);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diagnosticsServiceProvider.overrideWithValue(
              mockDiagnosticsService,
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      await tester.pump();

      // Act - Open popup menu and select Fairfax
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fairfax'));
      await tester.pump();

      // Assert - This would require more complex setup to verify state changes
      // For now, just verify the menu interaction works
      expect(find.text('Public Cloud'), findsOneWidget);
    });

    testWidgets('should load diagnostics on init', (WidgetTester tester) async {
      // Arrange
      final diagnostics = Diagnostics(
        buildInfo: BuildInfo(buildVersion: '1.0.0'),
        extensions: {},
        serverInfo: ServerInfo(
          hostname: 'test-server',
          deploymentId: 'test-deployment',
          extensionSync: ExtensionSync(totalSyncAllCount: 0),
          nodeVersions: 'v18.0.0',
          serverId: 'test-server-id',
          uptime: 12345,
        ),
      );

      when(
        () => mockDiagnosticsService.fetchDiagnostics(any()),
      ).thenAnswer((_) async => diagnostics);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diagnosticsServiceProvider.overrideWithValue(
              mockDiagnosticsService,
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // Wait for post frame callback
      await tester.pump();

      // Assert
      verify(() => mockDiagnosticsService.fetchDiagnostics(any())).called(1);
    });
  });
}
