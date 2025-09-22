import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';

void main() {
  group('Environment', () {
    test('should have correct values', () {
      expect(
        Environment.public.url,
        'https://hosting.portal.azure.net/api/diagnostics',
      );
      expect(Environment.public.displayName, 'Public Cloud');

      expect(
        Environment.fairfax.url,
        'https://hosting.azureportal.usgovcloudapi.net/api/diagnostics',
      );
      expect(Environment.fairfax.displayName, 'Fairfax');

      expect(
        Environment.mooncake.url,
        'https://hosting.azureportal.chinacloudapi.cn/api/diagnostics',
      );
      expect(Environment.mooncake.displayName, 'Mooncake');
    });
  });
}
