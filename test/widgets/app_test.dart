import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diagnostics_getwidget/widgets/app.dart';

void main() {
  group('DiagnosticsApp', () {
    testWidgets('builds MaterialApp with correct configuration', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(const ProviderScope(child: DiagnosticsApp()));

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);

      // Check that the app title is set correctly
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Azure Portal Extensions Dashboard');
      expect(materialApp.debugShowCheckedModeBanner, false);
      expect(materialApp.themeMode, ThemeMode.system);
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });
  });
}
