import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';

void main() {
  group('StageDefinition', () {
    test('should create with required fields', () {
      final stageDefinition = StageDefinition(
        stageDefinition: {
          'stage1': ['task1', 'task2'],
          'stage2': ['task3'],
        },
      );

      expect(stageDefinition.stageDefinition, {
        'stage1': ['task1', 'task2'],
        'stage2': ['task3'],
      });
    });

    test('fromJson should parse correctly', () {
      final json = {
        'build': ['compile', 'test'],
        'deploy': ['upload', 'restart'],
      };

      final stageDefinition = StageDefinition.fromJson(json);

      expect(stageDefinition.stageDefinition, {
        'build': ['compile', 'test'],
        'deploy': ['upload', 'restart'],
      });
    });

    test('fromJson should handle empty json', () {
      final json = <String, dynamic>{};

      final stageDefinition = StageDefinition.fromJson(json);

      expect(stageDefinition.stageDefinition, isEmpty);
    });

    test('fromJson should handle non-list values', () {
      final json = {
        'stage1': 'not-a-list',
        'stage2': ['task1'],
      };

      final stageDefinition = StageDefinition.fromJson(json);

      expect(stageDefinition.stageDefinition, {
        'stage1': [],
        'stage2': ['task1'],
      });
    });

    test('fromJson should handle mixed value types', () {
      final json = {
        'stage1': ['task1', 123, true],
        'stage2': ['task2'],
      };

      final stageDefinition = StageDefinition.fromJson(json);

      expect(stageDefinition.stageDefinition, {
        'stage1': ['task1', '123', 'true'],
        'stage2': ['task2'],
      });
    });
  });
}
