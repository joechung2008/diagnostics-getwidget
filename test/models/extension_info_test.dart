import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:diagnostics_getwidget/models.dart';

// Mock classes for testing
class MockConfiguration extends Mock implements Configuration {}

class MockStageDefinition extends Mock implements StageDefinition {}

void main() {
  group('ExtensionInfo', () {
    test('should create with required fields', () {
      final extensionInfo = ExtensionInfo(
        extensionName: 'test-extension',
        config: MockConfiguration(),
        stageDefinition: MockStageDefinition(),
      );

      expect(extensionInfo.extensionName, 'test-extension');
      expect(extensionInfo.config, isNotNull);
      expect(extensionInfo.stageDefinition, isNotNull);
    });

    test('should create with null optional fields', () {
      final extensionInfo = ExtensionInfo(extensionName: 'test-extension');

      expect(extensionInfo.extensionName, 'test-extension');
      expect(extensionInfo.config, isNull);
      expect(extensionInfo.stageDefinition, isNull);
    });

    test('fromJson should parse correctly', () {
      final json = {
        'extensionName': 'test-extension',
        'config': {'key': 'value'},
        'stageDefinition': {'stage': 'definition'},
      };

      final extensionInfo = ExtensionInfo.fromJson(json);

      expect(extensionInfo.extensionName, 'test-extension');
      expect(extensionInfo.config, isNotNull);
      expect(extensionInfo.stageDefinition, isNotNull);
    });

    test('fromJson should handle null config and stageDefinition', () {
      final json = {'extensionName': 'test-extension'};

      final extensionInfo = ExtensionInfo.fromJson(json);

      expect(extensionInfo.extensionName, 'test-extension');
      expect(extensionInfo.config, isNull);
      expect(extensionInfo.stageDefinition, isNull);
    });

    test('fromJson should handle null extensionName', () {
      final json = {
        'config': {'key': 'value'},
      };

      final extensionInfo = ExtensionInfo.fromJson(json);

      expect(extensionInfo.extensionName, '');
    });
  });
}
