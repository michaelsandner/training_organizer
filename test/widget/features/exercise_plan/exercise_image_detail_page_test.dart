import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_image_detail_page.dart';

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

        testWidgets('Then the background color matches exercise type',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
          expect(
            scaffold.backgroundColor,
            ExerciseType.technikKraul.color.withAlpha(30),
          );
        });

        testWidgets('Then the AppBar uses exercise type color',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          final appBar = tester.widget<AppBar>(find.byType(AppBar));
          expect(appBar.backgroundColor, ExerciseType.technikKraul.color);
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
                            const ExerciseImageDetailPage(exercise: exercise),
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

    group('Given an exercise without an image', () {
      const exerciseNoImage = Exercise(
        id: 5,
        name: 'Sprint',
        description: 'Schnell schwimmen',
        type: ExerciseType.ausdauer,
        unit: 'Meter',
      );

      group('When the page is rendered', () {
        testWidgets('Then a placeholder icon is shown', (tester) async {
          await tester.pumpWidget(buildWidget(ex: exerciseNoImage));

          expect(find.byIcon(Icons.pool), findsOneWidget);
        });

        testWidgets('Then a Hero widget wraps the placeholder',
            (tester) async {
          await tester.pumpWidget(buildWidget(ex: exerciseNoImage));

          final hero = tester.widget<Hero>(find.byType(Hero));
          expect(hero.tag, 'exercise-image-5');
        });

        testWidgets('Then the background color matches exercise type',
            (tester) async {
          await tester.pumpWidget(buildWidget(ex: exerciseNoImage));

          final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
          expect(
            scaffold.backgroundColor,
            ExerciseType.ausdauer.color.withAlpha(30),
          );
        });
      });
    });
  });
}
