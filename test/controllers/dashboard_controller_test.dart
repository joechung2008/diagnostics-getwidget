import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:diagnostics_getwidget/controllers/dashboard_controller.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/services.dart';

// Mock classes
class MockDiagnosticsService extends Mock implements DiagnosticsService {}

void main() {
  late ProviderContainer container;
  late MockDiagnosticsService mockDiagnosticsService;

  setUp(() {
    mockDiagnosticsService = MockDiagnosticsService();
    container = ProviderContainer(
      overrides: [
        diagnosticsServiceProvider.overrideWithValue(mockDiagnosticsService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('DashboardController', () {
    test('initial state should be DashboardState()', () {
      final state = container.read(dashboardControllerProvider);
      expect(state, const DashboardState());
    });

    group('loadDiagnostics', () {
      test(
        'should set loading state and then success state on successful fetch',
        () async {
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
            () => mockDiagnosticsService.fetchDiagnostics(Environment.public),
          ).thenAnswer((_) async => diagnostics);

          // Act
          await container
              .read(dashboardControllerProvider.notifier)
              .loadDiagnostics();

          // Assert
          final state = container.read(dashboardControllerProvider);
          expect(state.isLoading, false);
          expect(state.diagnostics, diagnostics);
          expect(state.selectedExtension, null);
          expect(state.error, null);

          verify(
            () => mockDiagnosticsService.fetchDiagnostics(Environment.public),
          ).called(1);
        },
      );

      test(
        'should set loading state and then error state on fetch failure',
        () async {
          // Arrange
          const errorMessage = 'Network error';
          when(
            () => mockDiagnosticsService.fetchDiagnostics(Environment.public),
          ).thenThrow(Exception(errorMessage));

          // Act
          await container
              .read(dashboardControllerProvider.notifier)
              .loadDiagnostics();

          // Assert
          final state = container.read(dashboardControllerProvider);
          expect(state.isLoading, false);
          expect(state.error, 'Exception: $errorMessage');
          expect(state.diagnostics, null);

          verify(
            () => mockDiagnosticsService.fetchDiagnostics(Environment.public),
          ).called(1);
        },
      );
    });

    group('setEnvironment', () {
      test('should update environment and trigger load diagnostics', () async {
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
          () => mockDiagnosticsService.fetchDiagnostics(Environment.fairfax),
        ).thenAnswer((_) async => diagnostics);

        // Act
        container
            .read(dashboardControllerProvider.notifier)
            .setEnvironment(Environment.fairfax);

        // Assert - wait for async operation
        await Future.delayed(Duration.zero);

        expect(
          container.read(dashboardControllerProvider).selectedEnvironment,
          Environment.fairfax,
        );
        expect(
          container.read(dashboardControllerProvider).selectedExtension,
          null,
        );
        expect(
          container.read(dashboardControllerProvider).showExtensionsList,
          true,
        );
        expect(
          container.read(dashboardControllerProvider).diagnostics,
          diagnostics,
        );
        expect(container.read(dashboardControllerProvider).isLoading, false);

        verify(
          () => mockDiagnosticsService.fetchDiagnostics(Environment.fairfax),
        ).called(1);
      });

      test('should not change state if environment is null', () {
        // Act
        container
            .read(dashboardControllerProvider.notifier)
            .setEnvironment(null);

        // Assert
        expect(
          container.read(dashboardControllerProvider),
          const DashboardState(),
        );
      });
    });

    group('selectExtension', () {
      test('should update selected extension', () {
        // Arrange
        final extension = ExtensionInfo(extensionName: 'test-extension');

        // Act
        container
            .read(dashboardControllerProvider.notifier)
            .selectExtension(extension);

        // Assert
        expect(
          container.read(dashboardControllerProvider).selectedExtension,
          extension,
        );
      });
    });

    group('toggleExtensionsList', () {
      test('should toggle showExtensionsList from true to false', () {
        // Act
        container
            .read(dashboardControllerProvider.notifier)
            .toggleExtensionsList();

        // Assert
        expect(
          container.read(dashboardControllerProvider).showExtensionsList,
          false,
        );
      });

      test('should toggle showExtensionsList from false to true', () {
        // Arrange
        container
            .read(dashboardControllerProvider.notifier)
            .toggleExtensionsList(); // Set to false
        expect(
          container.read(dashboardControllerProvider).showExtensionsList,
          false,
        );

        // Act
        container
            .read(dashboardControllerProvider.notifier)
            .toggleExtensionsList();

        // Assert
        expect(
          container.read(dashboardControllerProvider).showExtensionsList,
          true,
        );
      });
    });

    group('handleShortcut', () {
      test(
        'should select extension and hide list when extension exists and is info',
        () {
          // Arrange
          final extensionInfo = ExtensionInfo(extensionName: 'test-extension');
          final extension = Extension(info: extensionInfo);
          final diagnostics = Diagnostics(
            buildInfo: BuildInfo(buildVersion: '1.0.0'),
            extensions: {'test-extension': extension},
            serverInfo: ServerInfo(
              hostname: 'test-server',
              deploymentId: 'test-deployment',
              extensionSync: ExtensionSync(totalSyncAllCount: 0),
              nodeVersions: 'v18.0.0',
              serverId: 'test-server-id',
              uptime: 12345,
            ),
          );

          // Set diagnostics first
          container
              .read(dashboardControllerProvider.notifier)
              .setDiagnosticsForTesting(diagnostics);

          // Act
          container
              .read(dashboardControllerProvider.notifier)
              .handleShortcut('test-extension');

          // Assert
          final state = container.read(dashboardControllerProvider);
          expect(state.selectedExtension, extensionInfo);
          expect(state.showExtensionsList, false);
        },
      );

      test('should do nothing when extension does not exist', () {
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

        // Set diagnostics first
        container
            .read(dashboardControllerProvider.notifier)
            .setDiagnosticsForTesting(diagnostics);

        // Act
        container
            .read(dashboardControllerProvider.notifier)
            .handleShortcut('non-existent');

        // Assert
        final state = container.read(dashboardControllerProvider);
        expect(state.selectedExtension, null);
        expect(state.showExtensionsList, true); // default
      });

      test('should do nothing when extension exists but is not info', () {
        // Arrange
        final extension = Extension(
          error: ExtensionError(errorMessage: 'error', time: 'now'),
        );
        final diagnostics = Diagnostics(
          buildInfo: BuildInfo(buildVersion: '1.0.0'),
          extensions: {'test-extension': extension},
          serverInfo: ServerInfo(
            hostname: 'test-server',
            deploymentId: 'test-deployment',
            extensionSync: ExtensionSync(totalSyncAllCount: 0),
            nodeVersions: 'v18.0.0',
            serverId: 'test-server-id',
            uptime: 12345,
          ),
        );

        // Set diagnostics first
        container
            .read(dashboardControllerProvider.notifier)
            .setDiagnosticsForTesting(diagnostics);

        // Act
        container
            .read(dashboardControllerProvider.notifier)
            .handleShortcut('test-extension');

        // Assert
        final state = container.read(dashboardControllerProvider);
        expect(state.selectedExtension, null);
        expect(state.showExtensionsList, true);
      });
    });
  });
}
