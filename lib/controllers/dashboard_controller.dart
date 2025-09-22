import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models.dart';
import '../services.dart';

// Controller that manages dashboard state and business logic
class DashboardController extends StateNotifier<DashboardState> {
  final DiagnosticsService _diagnosticsService;

  DashboardController(this._diagnosticsService) : super(const DashboardState());

  Future<void> loadDiagnostics() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final diagnostics = await _diagnosticsService.fetchDiagnostics(
        state.selectedEnvironment,
      );
      state = state.copyWith(
        diagnostics: diagnostics,
        isLoading: false,
        selectedExtension: null, // Clear selection on new data
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void setEnvironment(Environment? environment) {
    if (environment != null) {
      state = state.copyWith(
        selectedEnvironment: environment,
        selectedExtension: null,
        showExtensionsList: true,
      );
      loadDiagnostics();
    }
  }

  void selectExtension(ExtensionInfo extension) {
    state = state.copyWith(selectedExtension: extension);
  }

  void toggleExtensionsList() {
    state = state.copyWith(showExtensionsList: !state.showExtensionsList);
  }

  void handleShortcut(String extensionName) {
    final diagnostics = state.diagnostics;
    if (diagnostics != null) {
      final extension = diagnostics.extensions[extensionName];
      if (extension != null && extension.isInfo) {
        selectExtension(extension.info!);
        state = state.copyWith(showExtensionsList: false);
      }
    }
  }
}

// Provider for the diagnostics service
final diagnosticsServiceProvider = Provider<DiagnosticsService>((ref) {
  return DiagnosticsService();
});

// Provider for the dashboard controller
final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      final diagnosticsService = ref.watch(diagnosticsServiceProvider);
      return DashboardController(diagnosticsService);
    });
