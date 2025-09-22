import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/widgets/server_info_tab.dart';

void main() {
  group('ServerInfoTab', () {
    testWidgets('displays server info in a table', (WidgetTester tester) async {
      // Arrange
      final extensionSync = ExtensionSync(totalSyncAllCount: 42);
      final serverInfo = ServerInfo(
        hostname: 'test-server',
        deploymentId: 'test-deployment',
        serverId: 'test-server-id',
        nodeVersions: 'v18.0.0',
        uptime: 12345,
        extensionSync: extensionSync,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ServerInfoTab(serverInfo: serverInfo)),
        ),
      );

      // Assert
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('Hostname'), findsOneWidget);
      expect(find.text('test-server'), findsOneWidget);
      expect(find.text('Deployment ID'), findsOneWidget);
      expect(find.text('test-deployment'), findsOneWidget);
      expect(find.text('Server ID'), findsOneWidget);
      expect(find.text('test-server-id'), findsOneWidget);
      expect(find.text('Node Versions'), findsOneWidget);
      expect(find.text('v18.0.0'), findsOneWidget);
      expect(find.text('Uptime'), findsOneWidget);
      expect(find.text('12345'), findsOneWidget);
      expect(
        find.text('Extension Sync | Total Sync All Count'),
        findsOneWidget,
      );
      expect(find.text('42'), findsOneWidget);
    });
  });
}
