import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_description_section.dart';

void main() {
  const exerciseWithoutExtras = Exercise(
    id: 1,
    name: 'Einschwimmen',
    description: 'Schwimme x Meter',
    type: ExerciseType.einschwimmen,
    unit: 'Meter',
  );

  const exerciseWithMaterialAndVarianten = Exercise(
    id: 2,
    name: 'Wasserball',
    description: 'Spiele Wasserball',
    type: ExerciseType.spiel,
    unit: 'Minuten',
    material: '1 Wasserball',
    varianten: 'Nur mit links werfen',
  );

  const exerciseWithMaterialOnly = Exercise(
    id: 3,
    name: 'Übung',
    description: 'Beschreibung',
    type: ExerciseType.kraft,
    unit: 'Minuten',
    material: 'Hanteln',
  );

  Widget buildWidget(Exercise exercise) {
    return MaterialApp(
      home: Scaffold(
        body: ExerciseDescriptionSection(exercise: exercise),
      ),
    );
  }

  group('ExerciseDescriptionSection', () {
    group('Given an exercise without material or varianten', () {
      group('When the widget is rendered', () {
        testWidgets('Then only the description is shown without headers',
            (tester) async {
          await tester.pumpWidget(buildWidget(exerciseWithoutExtras));

          expect(find.text('Schwimme x Meter'), findsOneWidget);
          expect(find.text('Ablauf'), findsNothing);
          expect(find.text('Material'), findsNothing);
          expect(find.text('Varianten'), findsNothing);
        });
      });
    });

    group('Given an exercise with material and varianten', () {
      group('When the widget is rendered', () {
        testWidgets('Then all sections with headers are shown',
            (tester) async {
          await tester
              .pumpWidget(buildWidget(exerciseWithMaterialAndVarianten));

          expect(find.text('Ablauf'), findsOneWidget);
          expect(find.text('Spiele Wasserball'), findsOneWidget);
          expect(find.text('Material'), findsOneWidget);
          expect(find.text('1 Wasserball'), findsOneWidget);
          expect(find.text('Varianten'), findsOneWidget);
          expect(find.text('Nur mit links werfen'), findsOneWidget);
        });
      });
    });

    group('Given an exercise with material only', () {
      group('When the widget is rendered', () {
        testWidgets('Then Ablauf and Material headers are shown',
            (tester) async {
          await tester.pumpWidget(buildWidget(exerciseWithMaterialOnly));

          expect(find.text('Ablauf'), findsOneWidget);
          expect(find.text('Beschreibung'), findsOneWidget);
          expect(find.text('Material'), findsOneWidget);
          expect(find.text('Hanteln'), findsOneWidget);
          expect(find.text('Varianten'), findsNothing);
        });
      });
    });
  });
}
