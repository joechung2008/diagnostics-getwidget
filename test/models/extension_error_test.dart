import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';

void main() {
  group('ExtensionError', () {
    test('should create with required fields', () {
      final extensionError = ExtensionError(
        errorMessage: 'Connection timeout',
        time: '2023-01-01T12:00:00Z',
      );

      expect(extensionError.errorMessage, 'Connection timeout');
      expect(extensionError.time, '2023-01-01T12:00:00Z');
    });

    test('fromJson should parse correctly', () {
      final json = {
        'errorMessage': 'Network error',
        'time': '2023-01-01T12:00:00.000Z',
      };

      final extensionError = ExtensionError.fromJson(json);

      expect(extensionError.errorMessage, 'Network error');
      expect(extensionError.time, '2023-01-01T12:00:00.000Z');
    });

    test('fromJson should handle null errorMessage', () {
      final json = {'time': '2023-01-01T12:00:00.000Z'};

      final extensionError = ExtensionError.fromJson(json);

      expect(extensionError.errorMessage, 'Unknown error');
      expect(extensionError.time, '2023-01-01T12:00:00.000Z');
    });

    test('fromJson should handle null time', () {
      final json = {'errorMessage': 'Error occurred'};

      final extensionError = ExtensionError.fromJson(json);

      expect(extensionError.errorMessage, 'Error occurred');
      expect(extensionError.time, '');
    });

    test('fromJson should handle non-string values', () {
      final json = {'errorMessage': 123, 'time': 456};

      final extensionError = ExtensionError.fromJson(json);

      expect(extensionError.errorMessage, '123');
      expect(extensionError.time, '456');
    });
  });
}
