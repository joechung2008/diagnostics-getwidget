import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';

void main() {
  group('ExtensionSync', () {
    test('should create with required fields', () {
      final extensionSync = ExtensionSync(totalSyncAllCount: 42);

      expect(extensionSync.totalSyncAllCount, 42);
    });

    test('fromJson should parse correctly', () {
      final json = {'totalSyncAllCount': 100};

      final extensionSync = ExtensionSync.fromJson(json);

      expect(extensionSync.totalSyncAllCount, 100);
    });

    test('fromJson should handle null totalSyncAllCount', () {
      final json = {'otherField': 'value'};

      final extensionSync = ExtensionSync.fromJson(json);

      expect(extensionSync.totalSyncAllCount, 0);
    });

    test('fromJson should handle non-numeric totalSyncAllCount', () {
      final json = {'totalSyncAllCount': 'not-a-number'};

      final extensionSync = ExtensionSync.fromJson(json);

      expect(extensionSync.totalSyncAllCount, 0);
    });

    test('fromJson should handle decimal totalSyncAllCount', () {
      final json = {'totalSyncAllCount': 15.5};

      final extensionSync = ExtensionSync.fromJson(json);

      expect(extensionSync.totalSyncAllCount, 15.5);
    });
  });
}
