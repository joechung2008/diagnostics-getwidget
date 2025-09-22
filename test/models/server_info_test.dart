import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';

void main() {
  group('ServerInfo', () {
    test('should create with required fields', () {
      final extensionSync = ExtensionSync(totalSyncAllCount: 50);
      final serverInfo = ServerInfo(
        deploymentId: 'dep-123',
        extensionSync: extensionSync,
        hostname: 'server.example.com',
        nodeVersions: 'v16.14.0',
        serverId: 'srv-456',
        uptime: 3600,
      );

      expect(serverInfo.deploymentId, 'dep-123');
      expect(serverInfo.extensionSync.totalSyncAllCount, 50);
      expect(serverInfo.hostname, 'server.example.com');
      expect(serverInfo.nodeVersions, 'v16.14.0');
      expect(serverInfo.serverId, 'srv-456');
      expect(serverInfo.uptime, 3600);
    });

    test('fromJson should parse correctly', () {
      final json = {
        'deploymentId': 'dep-789',
        'extensionSync': {'totalSyncAllCount': 75},
        'hostname': 'api.example.com',
        'nodeVersions': 'v18.12.0',
        'serverId': 'srv-101',
        'uptime': 7200,
      };

      final serverInfo = ServerInfo.fromJson(json);

      expect(serverInfo.deploymentId, 'dep-789');
      expect(serverInfo.extensionSync.totalSyncAllCount, 75);
      expect(serverInfo.hostname, 'api.example.com');
      expect(serverInfo.nodeVersions, 'v18.12.0');
      expect(serverInfo.serverId, 'srv-101');
      expect(serverInfo.uptime, 7200);
    });

    test('fromJson should handle null values', () {
      final json = <String, dynamic>{};

      final serverInfo = ServerInfo.fromJson(json);

      expect(serverInfo.deploymentId, '');
      expect(serverInfo.extensionSync.totalSyncAllCount, 0);
      expect(serverInfo.hostname, '');
      expect(serverInfo.nodeVersions, '');
      expect(serverInfo.serverId, '');
      expect(serverInfo.uptime, 0);
    });

    test('fromJson should handle invalid extensionSync', () {
      final json = {
        'deploymentId': 'dep-123',
        'extensionSync': 'not-a-map',
        'hostname': 'server.example.com',
      };

      final serverInfo = ServerInfo.fromJson(json);

      expect(serverInfo.deploymentId, 'dep-123');
      expect(serverInfo.extensionSync.totalSyncAllCount, 0);
      expect(serverInfo.hostname, 'server.example.com');
    });

    test('fromJson should handle non-numeric uptime', () {
      final json = {
        'deploymentId': 'dep-123',
        'extensionSync': {'totalSyncAllCount': 10},
        'hostname': 'server.example.com',
        'uptime': 'not-a-number',
      };

      final serverInfo = ServerInfo.fromJson(json);

      expect(serverInfo.uptime, 0);
    });

    test('fromJson should handle non-string values', () {
      final json = {
        'deploymentId': 123,
        'extensionSync': {'totalSyncAllCount': 10},
        'hostname': 456,
        'nodeVersions': 789,
        'serverId': 101,
        'uptime': 7200,
      };

      final serverInfo = ServerInfo.fromJson(json);

      expect(serverInfo.deploymentId, '123');
      expect(serverInfo.hostname, '456');
      expect(serverInfo.nodeVersions, '789');
      expect(serverInfo.serverId, '101');
      expect(serverInfo.uptime, 7200);
    });
  });
}
