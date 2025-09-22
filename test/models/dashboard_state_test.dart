import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';

void main() {
  group('DashboardState', () {
    test('should create with default values', () {
      const state = DashboardState();

      expect(state.selectedEnvironment, Environment.public);
      expect(state.diagnostics, isNull);
      expect(state.isLoading, false);
      expect(state.error, isNull);
      expect(state.selectedExtension, isNull);
      expect(state.showExtensionsList, true);
    });

    test('should create with custom values', () {
      const state = DashboardState(
        selectedEnvironment: Environment.fairfax,
        diagnostics: null,
        isLoading: true,
        error: 'Test error',
        selectedExtension: null,
        showExtensionsList: false,
      );

      expect(state.selectedEnvironment, Environment.fairfax);
      expect(state.isLoading, true);
      expect(state.error, 'Test error');
      expect(state.showExtensionsList, false);
    });

    test('copyWith should work correctly', () {
      const originalState = DashboardState(
        selectedEnvironment: Environment.public,
        isLoading: false,
        error: null,
        showExtensionsList: true,
      );

      final newState = originalState.copyWith(
        selectedEnvironment: Environment.fairfax,
        isLoading: true,
        error: 'New error',
        showExtensionsList: false,
      );

      expect(newState.selectedEnvironment, Environment.fairfax);
      expect(newState.isLoading, true);
      expect(newState.error, 'New error');
      expect(newState.showExtensionsList, false);

      // Original state should be unchanged
      expect(originalState.selectedEnvironment, Environment.public);
      expect(originalState.isLoading, false);
      expect(originalState.error, isNull);
      expect(originalState.showExtensionsList, true);
    });

    test('copyWith with null values should preserve original values', () {
      const originalState = DashboardState(
        selectedEnvironment: Environment.mooncake,
        isLoading: true,
        error: 'Original error',
        showExtensionsList: false,
      );

      final newState = originalState.copyWith();

      expect(newState.selectedEnvironment, Environment.mooncake);
      expect(newState.isLoading, true);
      expect(newState.error, 'Original error');
      expect(newState.showExtensionsList, false);
    });

    test('should be immutable', () {
      const state = DashboardState();
      expect(
        () => (state as dynamic).selectedEnvironment = Environment.fairfax,
        throwsNoSuchMethodError,
      );
    });
  });
}
