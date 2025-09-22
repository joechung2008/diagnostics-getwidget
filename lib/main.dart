import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets.dart';

// Riverpod is the single state management approach for this project.
void main() {
  runApp(const ProviderScope(child: DiagnosticsApp()));
}
