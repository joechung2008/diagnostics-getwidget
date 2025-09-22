import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets.dart';

// To switch between state management implementations:
//
// 1. Riverpod (default):
//    - Keep the ProviderScope wrapper below.
//    - In lib/widgets/app.dart, set home: const DashboardPage(),
//
// 2. Bloc:
//    - Remove the ProviderScope wrapper (just runApp(const DiagnosticsApp())).
//    - In lib/widgets/app.dart, set home: const DashboardPageBloc(),

void main() {
  runApp(const ProviderScope(child: DiagnosticsApp()));
}
