import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_carousel_row.dart';

void main() {
  const testExercises = [
    Exercise(
      id: 1,
      name: 'Einschwimmen Strecke',
      description: 'Schwimme x Meter',
      type: ExerciseType.einschwimmen,
      unit: 'Meter',
    ),
  ];

  Widget buildRow({
    VoidCallback? onMoveUp,
    VoidCallback? onMoveDown,
    VoidCallback? onRemove,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ExerciseCarouselRow(
          index: 0,
          selectedType: ExerciseType.einschwimmen,
          selectedExerciseId: 1,
          distance: 100,
          allExercises: testExercises,
          onTypeChanged: (_) {},
          onExerciseChanged: (_) {},
          onDistanceChanged: (_) {},
          onRemove: onRemove ?? () {},
          onMoveUp: onMoveUp,
          onMoveDown: onMoveDown,
        ),
      ),
    );
  }

  group('ExerciseCarouselRow', () {
    group('Given the row is in the middle of the list', () {
      group('When move buttons are rendered', () {
        testWidgets('Then both move up and move down buttons are shown', (
          tester,
        ) async {
          await tester.pumpWidget(buildRow(onMoveUp: () {}, onMoveDown: () {}));

          expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
          expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
        });

        testWidgets('Then both move up and move down buttons are enabled', (
          tester,
        ) async {
          await tester.pumpWidget(buildRow(onMoveUp: () {}, onMoveDown: () {}));

          final upButton = tester.widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.arrow_upward),
          );
          final downButton = tester.widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.arrow_downward),
          );

          expect(upButton.onPressed, isNotNull);
          expect(downButton.onPressed, isNotNull);
        });
      });
    });

    group('Given the row is at the top of the list', () {
      group('When move buttons are rendered', () {
        testWidgets('Then the move up button is disabled', (tester) async {
          await tester.pumpWidget(buildRow(onMoveUp: null, onMoveDown: () {}));

          final upButton = tester.widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.arrow_upward),
          );

          expect(upButton.onPressed, isNull);
        });

        testWidgets('Then the move down button is enabled', (tester) async {
          await tester.pumpWidget(buildRow(onMoveUp: null, onMoveDown: () {}));

          final downButton = tester.widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.arrow_downward),
          );

          expect(downButton.onPressed, isNotNull);
        });
      });
    });

    group('Given the row is at the bottom of the list', () {
      group('When move buttons are rendered', () {
        testWidgets('Then the move up button is enabled', (tester) async {
          await tester.pumpWidget(buildRow(onMoveUp: () {}, onMoveDown: null));

          final upButton = tester.widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.arrow_upward),
          );

          expect(upButton.onPressed, isNotNull);
        });

        testWidgets('Then the move down button is disabled', (tester) async {
          await tester.pumpWidget(buildRow(onMoveUp: () {}, onMoveDown: null));

          final downButton = tester.widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.arrow_downward),
          );

          expect(downButton.onPressed, isNull);
        });
      });
    });

    group('Given the title row is rendered', () {
      group('When collapse button presence is checked', () {
        testWidgets(
          'Then no redundant collapse button exists in the title action row',
          (tester) async {
            await tester.pumpWidget(buildRow());

            // The title row must not have a standalone expand_less/expand_more
            // icon outside of ExerciseCarouselNameRow.
            // There is exactly one collapse toggle (in the name row).
            expect(find.byIcon(Icons.expand_less), findsOneWidget);
          },
        );
      });
    });

    group('Given the delete button is rendered', () {
      group('When the delete button is tapped', () {
        testWidgets('Then the onRemove callback is called', (tester) async {
          var removed = false;
          await tester.pumpWidget(buildRow(onRemove: () => removed = true));

          await tester.tap(find.byIcon(Icons.delete_outline));
          await tester.pump();

          expect(removed, isTrue);
        });
      });
    });
  });
}
