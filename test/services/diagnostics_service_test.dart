import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/services/diagnostics_service.dart';

// Mock classes for testing
class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('DiagnosticsService', () {
    late DiagnosticsService diagnosticsService;
    late MockHttpClient mockClient;

    setUp(() {
      mockClient = MockHttpClient();
      diagnosticsService = DiagnosticsService(mockClient);
    });

    tearDown(() {
      mockClient.close();
    });

    group('fetchDiagnostics', () {
      test('returns Diagnostics when API call is successful', () async {
        // Arrange
        const testJsonResponse = '''
        {
          "buildInfo": {
            "buildVersion": "1.0.0"
          },
          "extensions": {},
          "serverInfo": {
            "hostname": "test-server",
            "deploymentId": "test-deployment",
            "extensionSync": {"totalSyncAllCount": 0},
            "nodeVersions": "v18.0.0",
            "serverId": "test-server-id",
            "uptime": 12345
          }
        }
        ''';

        final response = http.Response(testJsonResponse, 200);
        final environment = Environment.public;

        when(
          () => mockClient.get(Uri.parse(environment.url)),
        ).thenAnswer((_) async => response);

        // Act
        final result = await diagnosticsService.fetchDiagnostics(environment);

        // Assert
        expect(result, isA<Diagnostics>());
        expect(result.buildInfo.buildVersion, '1.0.0');
        expect(result.serverInfo.hostname, 'test-server');
        verify(() => mockClient.get(Uri.parse(environment.url))).called(1);
      });

      test(
        'throws Exception when API call fails with non-200 status code',
        () async {
          // Arrange
          final response = http.Response('Not Found', 404);
          final environment = Environment.public;

          when(
            () => mockClient.get(Uri.parse(environment.url)),
          ).thenAnswer((_) async => response);

          // Act & Assert
          expect(
            () => diagnosticsService.fetchDiagnostics(environment),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Failed to fetch diagnostics: 404'),
              ),
            ),
          );
          verify(() => mockClient.get(Uri.parse(environment.url))).called(1);
        },
      );

      test('throws Exception when JSON parsing fails', () async {
        // Arrange
        const invalidJson = '{ invalid json }';

        final response = http.Response(invalidJson, 200);
        final environment = Environment.public;

        when(
          () => mockClient.get(Uri.parse(environment.url)),
        ).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => diagnosticsService.fetchDiagnostics(environment),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to parse diagnostics response'),
            ),
          ),
        );
        verify(() => mockClient.get(Uri.parse(environment.url))).called(1);
      });
    });
  });
}
