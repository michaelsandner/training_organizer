import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_image_detail_page.dart';

void main() {
  const exercise = Exercise(
    id: 1,
    name: 'Kraul Beine',
    description: 'Schwimme nur Kraul Beine',
    type: ExerciseType.technikKraul,
    imageName: 'kraul_beine.png',
    unit: 'Meter',
    material: 'Schwimmbrett',
    varianten: 'Mit Flossen',
  );

  Widget buildWidget({Exercise ex = exercise}) {
    return MaterialApp(
      home: ExerciseImageDetailPage(exercise: ex),
    );
  }

  group('ExerciseImageDetailPage', () {
    group('Given an exercise with image and description', () {
      group('When the page is rendered', () {
        testWidgets('Then the exercise name is shown in the app bar',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(find.text('Kraul Beine'), findsOneWidget);
        });

        testWidgets('Then a Hero widget wraps the image', (tester) async {
          await tester.pumpWidget(buildWidget());

          final hero = tester.widget<Hero>(find.byType(Hero));
          expect(hero.tag, 'exercise-image-1');
        });

        testWidgets('Then the description section is displayed',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(find.text('Schwimme nur Kraul Beine'), findsOneWidget);
          expect(find.text('Material'), findsOneWidget);
          expect(find.text('Schwimmbrett'), findsOneWidget);
          expect(find.text('Varianten'), findsOneWidget);
          expect(find.text('Mit Flossen'), findsOneWidget);
        });
      });

      group('When the back button is tapped', () {
        testWidgets('Then the page is popped', (tester) async {
          await tester.pumpWidget(MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ExerciseImageDetailPage(exercise: exercise),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ));

          await tester.tap(find.text('Open'));
          await tester.pumpAndSettle();

          expect(find.byType(ExerciseImageDetailPage), findsOneWidget);

          await tester.tap(find.byType(BackButton));
          await tester.pumpAndSettle();

          expect(find.byType(ExerciseImageDetailPage), findsNothing);
        });
      });
    });
  });
}
