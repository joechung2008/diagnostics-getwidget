import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';

void main() {
  group('Configuration', () {
    test('should create with required fields', () {
      final configuration = Configuration(
        config: {'key1': 'value1', 'key2': 'value2'},
      );

      expect(configuration.config, {'key1': 'value1', 'key2': 'value2'});
    });

    test('fromJson should parse correctly', () {
      final json = {'apiKey': 'secret', 'timeout': '30'};

      final configuration = Configuration.fromJson(json);

      expect(configuration.config, {'apiKey': 'secret', 'timeout': '30'});
    });

    test('fromJson should handle empty json', () {
      final json = <String, dynamic>{};

      final configuration = Configuration.fromJson(json);

      expect(configuration.config, isEmpty);
    });

    test('fromJson should handle null values', () {
      final json = {'key1': 'value1', 'key2': null, 'key3': 123};

      final configuration = Configuration.fromJson(json);

      expect(configuration.config, {
        'key1': 'value1',
        'key2': '',
        'key3': '123',
      });
    });
  });
}
