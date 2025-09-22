import 'package:flutter/material.dart';
import '../models.dart';

const _copyWithSentinel = Object();

@immutable
class DashboardState {
  const DashboardState({
    this.selectedEnvironment = Environment.public,
    this.diagnostics,
    this.isLoading = false,
    this.error,
    this.selectedExtension,
    this.showExtensionsList = true,
  });

  final Environment selectedEnvironment;
  final Diagnostics? diagnostics;
  final bool isLoading;
  final String? error;
  final ExtensionInfo? selectedExtension;
  final bool showExtensionsList;

  DashboardState copyWith({
    Environment? selectedEnvironment,
    Object? diagnostics = _copyWithSentinel,
    bool? isLoading,
    Object? error = _copyWithSentinel,
    Object? selectedExtension = _copyWithSentinel,
    bool? showExtensionsList,
  }) {
    return DashboardState(
      selectedEnvironment: selectedEnvironment ?? this.selectedEnvironment,
      diagnostics: identical(diagnostics, _copyWithSentinel)
          ? this.diagnostics
          : diagnostics as Diagnostics?,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _copyWithSentinel)
          ? this.error
          : error as String?,
      selectedExtension: identical(selectedExtension, _copyWithSentinel)
          ? this.selectedExtension
          : selectedExtension as ExtensionInfo?,
      showExtensionsList: showExtensionsList ?? this.showExtensionsList,
    );
  }
}
