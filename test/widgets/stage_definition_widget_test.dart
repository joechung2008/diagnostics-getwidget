import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diagnostics_getwidget/models.dart';
import 'package:diagnostics_getwidget/widgets/stage_definition_widget.dart';

void main() {
  group('StageDefinitionWidget', () {
    testWidgets('displays stage definitions in a table', (
      WidgetTester tester,
    ) async {
      // Arrange
      final stageDefinition = StageDefinition(
        stageDefinition: {
          'stage1': ['value1', 'value2'],
          'stage2': ['value3'],
        },
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StageDefinitionWidget(stageDefinition: stageDefinition),
          ),
        ),
      );

      // Assert
      expect(find.text('Stage Definitions'), findsOneWidget);
      expect(find.text('Key'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('stage1'), findsOneWidget);
      expect(find.text('value1, value2'), findsOneWidget);
      expect(find.text('stage2'), findsOneWidget);
      expect(find.text('value3'), findsOneWidget);
    });

    testWidgets('displays empty stage definitions', (
      WidgetTester tester,
    ) async {
      // Arrange
      final stageDefinition = StageDefinition(stageDefinition: {});

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StageDefinitionWidget(stageDefinition: stageDefinition),
          ),
        ),
      );

      // Assert
      expect(find.text('Stage Definitions'), findsOneWidget);
      expect(find.text('Key'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      // No data rows should be present
      expect(find.text('stage1'), findsNothing);
    });

    testWidgets('displays single value correctly', (WidgetTester tester) async {
      // Arrange
      final stageDefinition = StageDefinition(
        stageDefinition: {
          'singleStage': ['singleValue'],
        },
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StageDefinitionWidget(stageDefinition: stageDefinition),
          ),
        ),
      );

      // Assert
      expect(find.text('singleStage'), findsOneWidget);
      expect(find.text('singleValue'), findsOneWidget);
    });
  });
}
