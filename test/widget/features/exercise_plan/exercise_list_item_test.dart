import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_list_item.dart';

void main() {
  const exercise = Exercise(
    id: 1,
    name: 'Einschwimmen Strecke',
    description: 'Es wird x Meter lang locker geschwommen',
    type: ExerciseType.einschwimmen,
    unit: 'Meter',
  );

  const exerciseWithImage = Exercise(
    id: 2,
    name: 'Kraul Beine',
    description: 'Schwimme nur Kraul Beine',
    type: ExerciseType.technikKraul,
    imageName: 'kraul_beine.png',
    unit: 'Meter',
  );

  Widget buildWidget({
    Exercise ex = exercise,
    bool collapseAll = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ExerciseListItem(
          exercise: ex,
          collapseAll: collapseAll,
        ),
      ),
    );
  }

  group('ExerciseListItem', () {
    group('Given a collapsed list item', () {
      group('When the item is rendered', () {
        testWidgets('Then only the exercise name is displayed',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(find.text('Einschwimmen Strecke'), findsOneWidget);
          expect(
            find.text('Es wird x Meter lang locker geschwommen'),
            findsNothing,
          );
          expect(find.text('#1'), findsNothing);
        });
      });

      group('When the item is tapped', () {
        testWidgets('Then the details are expanded', (tester) async {
          await tester.pumpWidget(buildWidget());

          await tester.tap(find.text('Einschwimmen Strecke'));
          await tester.pump();

          expect(find.text('Einschwimmen Strecke'), findsOneWidget);
          expect(
            find.text('Es wird x Meter lang locker geschwommen'),
            findsOneWidget,
          );
          expect(find.text('#1'), findsOneWidget);
          expect(find.text('Einschwimmen'), findsOneWidget);
          expect(find.text('Meter'), findsOneWidget);
        });
      });
    });

    group('Given an expanded list item', () {
      group('When the item is tapped', () {
        testWidgets('Then the details are collapsed', (tester) async {
          await tester.pumpWidget(buildWidget(collapseAll: false));

          // Item starts expanded (collapseAll: false means not collapsed)
          expect(
            find.text('Es wird x Meter lang locker geschwommen'),
            findsOneWidget,
          );

          await tester.tap(find.text('Einschwimmen Strecke'));
          await tester.pump();

          expect(
            find.text('Es wird x Meter lang locker geschwommen'),
            findsNothing,
          );
        });
      });
    });

    group('Given an exercise with an image', () {
      group('When the item is expanded', () {
        testWidgets('Then the show image button is displayed',
            (tester) async {
          await tester.pumpWidget(buildWidget(
            ex: exerciseWithImage,
            collapseAll: false,
          ));

          expect(find.text('Bild anzeigen'), findsOneWidget);
        });
      });
    });

    group('Given an exercise without an image', () {
      group('When the item is expanded', () {
        testWidgets('Then no show image button is displayed', (tester) async {
          await tester.pumpWidget(buildWidget(collapseAll: false));

          expect(find.text('Bild anzeigen'), findsNothing);
        });
      });
    });

    group('Given collapseAll changes', () {
      group('When collapseAll switches to true', () {
        testWidgets('Then the item becomes collapsed', (tester) async {
          await tester.pumpWidget(buildWidget(collapseAll: false));

          // Initially expanded
          expect(
            find.text('Es wird x Meter lang locker geschwommen'),
            findsOneWidget,
          );

          // Rebuild with collapseAll: true
          await tester.pumpWidget(buildWidget(collapseAll: true));

          expect(
            find.text('Es wird x Meter lang locker geschwommen'),
            findsNothing,
          );
        });
      });
    });
  });
}
