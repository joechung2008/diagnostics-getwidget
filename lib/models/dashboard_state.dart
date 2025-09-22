import 'package:flutter/material.dart';
import '../models.dart';

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
    Diagnostics? diagnostics,
    bool? isLoading,
    String? error,
    ExtensionInfo? selectedExtension,
    bool? showExtensionsList,
  }) {
    return DashboardState(
      selectedEnvironment: selectedEnvironment ?? this.selectedEnvironment,
      diagnostics: diagnostics ?? this.diagnostics,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedExtension: selectedExtension ?? this.selectedExtension,
      showExtensionsList: showExtensionsList ?? this.showExtensionsList,
    );
  }
}
