import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';

void main() {
  group('BuildInfo', () {
    test('should create with required fields', () {
      final buildInfo = BuildInfo(buildVersion: '1.2.3');

      expect(buildInfo.buildVersion, '1.2.3');
    });

    test('fromJson should parse correctly', () {
      final json = {'buildVersion': '2.0.1'};

      final buildInfo = BuildInfo.fromJson(json);

      expect(buildInfo.buildVersion, '2.0.1');
    });

    test('fromJson should handle null buildVersion', () {
      final json = {'otherField': 'value'};

      final buildInfo = BuildInfo.fromJson(json);

      expect(buildInfo.buildVersion, 'Unknown');
    });

    test('fromJson should handle non-string buildVersion', () {
      final json = {'buildVersion': 123};

      final buildInfo = BuildInfo.fromJson(json);

      expect(buildInfo.buildVersion, '123');
    });
  });
}
