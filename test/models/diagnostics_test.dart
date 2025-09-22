import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:diagnostics_getwidget/models.dart';

// Mock classes for testing
class MockBuildInfo extends Mock implements BuildInfo {}

class MockServerInfo extends Mock implements ServerInfo {}

class MockExtensionInfo extends Mock implements ExtensionInfo {}

void main() {
  group('Diagnostics', () {
    late MockBuildInfo mockBuildInfo;
    late MockServerInfo mockServerInfo;

    setUp(() {
      mockBuildInfo = MockBuildInfo();
      mockServerInfo = MockServerInfo();
    });

    test('should create with required fields', () {
      final diagnostics = Diagnostics(
        buildInfo: mockBuildInfo,
        extensions: {'test': Extension(info: MockExtensionInfo())},
        serverInfo: mockServerInfo,
      );

      expect(diagnostics.buildInfo, mockBuildInfo);
      expect(diagnostics.extensions, isNotEmpty);
      expect(diagnostics.serverInfo, mockServerInfo);
    });

    test('fromJson should parse correctly', () {
      final json = {
        'buildInfo': {'version': '1.0.0'},
        'extensions': {
          'test-extension': {'extensionName': 'test-extension'},
        },
        'serverInfo': {'host': 'localhost'},
      };

      final diagnostics = Diagnostics.fromJson(json);

      expect(diagnostics.buildInfo, isNotNull);
      expect(diagnostics.extensions, isNotEmpty);
      expect(diagnostics.extensions.containsKey('test-extension'), true);
      expect(diagnostics.serverInfo, isNotNull);
    });

    test('fromJson should handle empty extensions', () {
      final json = {
        'buildInfo': {'version': '1.0.0'},
        'extensions': {},
        'serverInfo': {'host': 'localhost'},
      };

      final diagnostics = Diagnostics.fromJson(json);

      expect(diagnostics.extensions, isEmpty);
    });

    test('fromJson should skip invalid extension entries', () {
      final json = {
        'buildInfo': {'version': '1.0.0'},
        'extensions': {
          'valid': {'extensionName': 'valid-extension'},
          'invalid': 'not-a-map',
        },
        'serverInfo': {'host': 'localhost'},
      };

      final diagnostics = Diagnostics.fromJson(json);

      expect(diagnostics.extensions.length, 1);
      expect(diagnostics.extensions.containsKey('valid'), true);
      expect(diagnostics.extensions.containsKey('invalid'), false);
    });
  });
}
