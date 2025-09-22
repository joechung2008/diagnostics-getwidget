import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:diagnostics_getwidget/models.dart';

// Mock classes for testing
class MockExtensionInfo extends Mock implements ExtensionInfo {}

class MockExtensionError extends Mock implements ExtensionError {}

void main() {
  group('Extension', () {
    test('should create info extension', () {
      final extension = Extension(info: MockExtensionInfo());

      expect(extension.info, isNotNull);
      expect(extension.error, isNull);
      expect(extension.isInfo, true);
      expect(extension.isError, false);
    });

    test('should create error extension', () {
      final extension = Extension(error: MockExtensionError());

      expect(extension.info, isNull);
      expect(extension.error, isNotNull);
      expect(extension.isInfo, false);
      expect(extension.isError, true);
    });

    test('fromJson should create info extension', () {
      final json = {
        'extensionName': 'test-extension',
        'config': {'some': 'config'},
        'stageDefinition': {'some': 'definition'},
      };

      final extension = Extension.fromJson(json);

      expect(extension.isInfo, true);
      expect(extension.isError, false);
      expect(extension.info, isNotNull);
    });

    test('fromJson should create error extension', () {
      final json = {
        'lastError': {
          'message': 'Test error',
          'timestamp': '2023-01-01T00:00:00Z',
        },
      };

      final extension = Extension.fromJson(json);

      expect(extension.isInfo, false);
      expect(extension.isError, true);
      expect(extension.error, isNotNull);
    });

    test('fromJson should throw on invalid json', () {
      final json = {'invalid': 'data'};

      expect(() => Extension.fromJson(json), throwsFormatException);
    });
  });
}
