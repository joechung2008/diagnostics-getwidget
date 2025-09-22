import 'package:flutter_bloc/flutter_bloc.dart';
import '../models.dart';
import '../services.dart';

// Events
abstract class DashboardEvent {}

class LoadDiagnosticsEvent extends DashboardEvent {}

class ChangeEnvironmentEvent extends DashboardEvent {
  final Environment? environment;
  ChangeEnvironmentEvent(this.environment);
}

class SelectExtensionEvent extends DashboardEvent {
  final ExtensionInfo extension;
  SelectExtensionEvent(this.extension);
}

class ToggleExtensionsListEvent extends DashboardEvent {}

class HandleShortcutEvent extends DashboardEvent {
  final String extensionName;
  HandleShortcutEvent(this.extensionName);
}

// Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DiagnosticsService _diagnosticsService;

  DashboardBloc(this._diagnosticsService) : super(const DashboardState()) {
    on<LoadDiagnosticsEvent>(_onLoadDiagnostics);
    on<ChangeEnvironmentEvent>(_onChangeEnvironment);
    on<SelectExtensionEvent>(_onSelectExtension);
    on<ToggleExtensionsListEvent>(_onToggleExtensionsList);
    on<HandleShortcutEvent>(_onHandleShortcut);
  }

  Future<void> _onLoadDiagnostics(
    LoadDiagnosticsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final diagnostics = await _diagnosticsService.fetchDiagnostics(
        state.selectedEnvironment,
      );
      emit(
        state.copyWith(
          diagnostics: diagnostics,
          isLoading: false,
          selectedExtension: null, // Clear selection on new data
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onChangeEnvironment(
    ChangeEnvironmentEvent event,
    Emitter<DashboardState> emit,
  ) {
    if (event.environment != null) {
      emit(
        state.copyWith(
          selectedEnvironment: event.environment,
          selectedExtension: null,
          showExtensionsList: true,
        ),
      );
      add(LoadDiagnosticsEvent());
    }
  }

  void _onSelectExtension(
    SelectExtensionEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(selectedExtension: event.extension));
  }

  void _onToggleExtensionsList(
    ToggleExtensionsListEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(showExtensionsList: !state.showExtensionsList));
  }

  void _onHandleShortcut(
    HandleShortcutEvent event,
    Emitter<DashboardState> emit,
  ) {
    final diagnostics = state.diagnostics;
    if (diagnostics != null) {
      final extension = diagnostics.extensions[event.extensionName];
      if (extension != null && extension.isInfo) {
        emit(
          state.copyWith(
            selectedExtension: extension.info,
            showExtensionsList: false,
          ),
        );
      }
    }
  }
}
