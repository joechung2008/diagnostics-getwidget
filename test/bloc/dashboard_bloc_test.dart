import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:diagnostics_getwidget/bloc/dashboard_bloc.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/services.dart';

// Mock classes
class MockDiagnosticsService extends Mock implements DiagnosticsService {}

void main() {
  late DashboardBloc dashboardBloc;
  late MockDiagnosticsService mockDiagnosticsService;

  setUp(() {
    mockDiagnosticsService = MockDiagnosticsService();
    dashboardBloc = DashboardBloc(mockDiagnosticsService);
  });

  tearDown(() {
    dashboardBloc.close();
  });

  group('DashboardBloc', () {
    test('initial state should be DashboardState()', () {
      expect(dashboardBloc.state, const DashboardState());
    });

    group('LoadDiagnosticsEvent', () {
      test(
        'should emit loading state and then success state on successful fetch',
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
          dashboardBloc.add(LoadDiagnosticsEvent());

          // Assert - wait for async operation
          await Future.delayed(Duration.zero);
          expect(dashboardBloc.state.isLoading, false);
          expect(dashboardBloc.state.diagnostics, diagnostics);
          expect(dashboardBloc.state.selectedExtension, null);
          expect(dashboardBloc.state.error, null);

          verify(
            () => mockDiagnosticsService.fetchDiagnostics(Environment.public),
          ).called(1);
        },
      );

      test(
        'should emit loading state and then error state on fetch failure',
        () async {
          // Arrange
          const errorMessage = 'Network error';
          when(
            () => mockDiagnosticsService.fetchDiagnostics(Environment.public),
          ).thenThrow(Exception(errorMessage));

          // Act
          dashboardBloc.add(LoadDiagnosticsEvent());

          // Assert - wait for async operation
          await Future.delayed(Duration.zero);
          expect(dashboardBloc.state.isLoading, false);
          expect(dashboardBloc.state.error, 'Exception: $errorMessage');
          expect(dashboardBloc.state.diagnostics, null);

          verify(
            () => mockDiagnosticsService.fetchDiagnostics(Environment.public),
          ).called(1);
        },
      );
    });

    group('ChangeEnvironmentEvent', () {
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
        dashboardBloc.add(ChangeEnvironmentEvent(Environment.fairfax));

        // Assert - wait for async operation
        await Future.delayed(Duration.zero);
        expect(dashboardBloc.state.selectedEnvironment, Environment.fairfax);
        expect(dashboardBloc.state.selectedExtension, null);
        expect(dashboardBloc.state.showExtensionsList, true);
        expect(dashboardBloc.state.diagnostics, diagnostics);
        expect(dashboardBloc.state.isLoading, false);

        verify(
          () => mockDiagnosticsService.fetchDiagnostics(Environment.fairfax),
        ).called(1);
      });

      test('should not change state if environment is null', () async {
        // Act
        dashboardBloc.add(ChangeEnvironmentEvent(null));

        // Assert - no state change expected
        expect(dashboardBloc.state, const DashboardState());
      });
    });

    group('SelectExtensionEvent', () {
      test('should update selected extension', () async {
        // Arrange
        final extension = ExtensionInfo(extensionName: 'test-extension');

        // Act
        dashboardBloc.add(SelectExtensionEvent(extension));

        // Assert
        await Future.delayed(Duration.zero);
        expect(dashboardBloc.state.selectedExtension, extension);
      });
    });

    group('ToggleExtensionsListEvent', () {
      test('should toggle showExtensionsList from true to false', () async {
        // Act
        dashboardBloc.add(ToggleExtensionsListEvent());

        // Assert
        await Future.delayed(Duration.zero);
        expect(dashboardBloc.state.showExtensionsList, false);
      });

      test('should toggle showExtensionsList from false to true', () async {
        // Arrange
        dashboardBloc.add(ToggleExtensionsListEvent()); // Set to false first
        await Future.delayed(Duration.zero);
        expect(dashboardBloc.state.showExtensionsList, false);

        // Act
        dashboardBloc.add(ToggleExtensionsListEvent());

        // Assert
        await Future.delayed(Duration.zero);
        expect(dashboardBloc.state.showExtensionsList, true);
      });
    });

    group('HandleShortcutEvent', () {
      test(
        'should select extension and hide list when extension exists and is info',
        () async {
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
          dashboardBloc.emit(DashboardState(diagnostics: diagnostics));

          // Act
          dashboardBloc.add(HandleShortcutEvent('test-extension'));

          // Assert
          await Future.delayed(Duration.zero);
          expect(dashboardBloc.state.selectedExtension, extensionInfo);
          expect(dashboardBloc.state.showExtensionsList, false);
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
        dashboardBloc.emit(DashboardState(diagnostics: diagnostics));

        // Act
        dashboardBloc.add(HandleShortcutEvent('non-existent'));

        // Assert - no state change expected
        expect(dashboardBloc.state.diagnostics, diagnostics);
        expect(dashboardBloc.state.selectedExtension, null);
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
        dashboardBloc.emit(DashboardState(diagnostics: diagnostics));

        // Act
        dashboardBloc.add(HandleShortcutEvent('test-extension'));

        // Assert - no state change expected
        expect(dashboardBloc.state.diagnostics, diagnostics);
        expect(dashboardBloc.state.selectedExtension, null);
      });
    });
  });
}
