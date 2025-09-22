import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:diagnostics_getwidget/controllers/dashboard_controller.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/services.dart';

// Mock classes
class MockDiagnosticsService extends Mock implements DiagnosticsService {}

void main() {
  late DashboardController dashboardController;
  late MockDiagnosticsService mockDiagnosticsService;

  setUp(() {
    mockDiagnosticsService = MockDiagnosticsService();
    dashboardController = DashboardController(mockDiagnosticsService);
  });

  group('DashboardController', () {
    test('initial state should be DashboardState()', () {
      expect(dashboardController.state, const DashboardState());
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
          await dashboardController.loadDiagnostics();

          // Assert
          expect(dashboardController.state.isLoading, false);
          expect(dashboardController.state.diagnostics, diagnostics);
          expect(dashboardController.state.selectedExtension, null);
          expect(dashboardController.state.error, null);

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
          await dashboardController.loadDiagnostics();

          // Assert
          expect(dashboardController.state.isLoading, false);
          expect(dashboardController.state.error, 'Exception: $errorMessage');
          expect(dashboardController.state.diagnostics, null);

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
        dashboardController.setEnvironment(Environment.fairfax);

        // Assert - wait for async operation
        await Future.delayed(Duration.zero);

        expect(
          dashboardController.state.selectedEnvironment,
          Environment.fairfax,
        );
        expect(dashboardController.state.selectedExtension, null);
        expect(dashboardController.state.showExtensionsList, true);
        expect(dashboardController.state.diagnostics, diagnostics);
        expect(dashboardController.state.isLoading, false);

        verify(
          () => mockDiagnosticsService.fetchDiagnostics(Environment.fairfax),
        ).called(1);
      });

      test('should not change state if environment is null', () {
        // Act
        dashboardController.setEnvironment(null);

        // Assert
        expect(dashboardController.state, const DashboardState());
      });
    });

    group('selectExtension', () {
      test('should update selected extension', () {
        // Arrange
        final extension = ExtensionInfo(extensionName: 'test-extension');

        // Act
        dashboardController.selectExtension(extension);

        // Assert
        expect(dashboardController.state.selectedExtension, extension);
      });
    });

    group('toggleExtensionsList', () {
      test('should toggle showExtensionsList from true to false', () {
        // Act
        dashboardController.toggleExtensionsList();

        // Assert
        expect(dashboardController.state.showExtensionsList, false);
      });

      test('should toggle showExtensionsList from false to true', () {
        // Arrange
        dashboardController.toggleExtensionsList(); // Set to false
        expect(dashboardController.state.showExtensionsList, false);

        // Act
        dashboardController.toggleExtensionsList();

        // Assert
        expect(dashboardController.state.showExtensionsList, true);
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
          dashboardController.state = DashboardState(diagnostics: diagnostics);

          // Act
          dashboardController.handleShortcut('test-extension');

          // Assert
          expect(dashboardController.state.selectedExtension, extensionInfo);
          expect(dashboardController.state.showExtensionsList, false);
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
        dashboardController.state = DashboardState(diagnostics: diagnostics);

        // Act
        dashboardController.handleShortcut('non-existent');

        // Assert
        expect(dashboardController.state.selectedExtension, null);
        expect(dashboardController.state.showExtensionsList, true); // default
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
        dashboardController.state = DashboardState(diagnostics: diagnostics);

        // Act
        dashboardController.handleShortcut('test-extension');

        // Assert
        expect(dashboardController.state.selectedExtension, null);
        expect(dashboardController.state.showExtensionsList, true);
      });
    });
  });
}
