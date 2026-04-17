import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_item.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_description_section.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_link_image_row.dart';

void main() {
  const exercise = Exercise(
    id: 1,
    name: 'Einschwimmen Strecke',
    description: 'Es wird x Meter lang locker geschwommen',
    type: ExerciseType.einschwimmen,
    unit: 'Meter',
  );

  Widget buildCarouselItem() {
    return MaterialApp(
      home: Scaffold(
        body: ExerciseCarouselItem(
          exercise: exercise,
          distance: 100,
          color: exercise.type.color,
          onDistanceChanged: (_) {},
        ),
      ),
    );
  }

  Widget buildCarousel() {
    return MaterialApp(
      home: Scaffold(
        body: ExerciseCarousel(
          exercises: const [exercise],
          selectedExerciseId: 1,
          selectedType: ExerciseType.einschwimmen,
          distance: 100,
          onExerciseChanged: (_) {},
          onDistanceChanged: (_) {},
        ),
      ),
    );
  }

  group('ExerciseCarouselItem', () {
    group('Given the swipe card is rendered', () {
      group('When image and description are shown', () {
        testWidgets('Then their top edges are aligned', (tester) async {
          await tester.pumpWidget(buildCarouselItem());

          final imageTop = tester.getTopLeft(find.byType(ExerciseLinkImageRow)).dy;
          final descriptionTop =
              tester.getTopLeft(find.byType(ExerciseDescriptionSection)).dy;

          expect(imageTop, equals(descriptionTop));
        });
      });

      group('When distance input and unit label are shown', () {
        testWidgets('Then their vertical centers are aligned', (tester) async {
          await tester.pumpWidget(buildCarouselItem());

          final inputCenterY = tester.getCenter(find.byType(TextFormField)).dy;
          final unitCenterY = tester.getCenter(find.text('Meter')).dy;

          expect((inputCenterY - unitCenterY).abs(), lessThanOrEqualTo(1));
        });

        testWidgets('Then the unit text uses compact styling', (tester) async {
          await tester.pumpWidget(buildCarouselItem());

          final unitText = tester.widget<Text>(find.text('Meter'));

          expect(unitText.style?.fontSize, 14);
          expect(unitText.style?.height, 1.1);
        });
      });

      group('When card color is applied', () {
        testWidgets('Then it uses the same alpha as the swipe container',
            (tester) async {
          await tester.pumpWidget(buildCarouselItem());

          final containerFinder = find.byWidgetPredicate((widget) {
            if (widget is! Container) {
              return false;
            }
            final decoration = widget.decoration;
            if (decoration is! BoxDecoration) {
              return false;
            }

            final border = decoration.border;
            return decoration.color == exercise.type.color.withAlpha(30) &&
                decoration.borderRadius == BorderRadius.circular(12) &&
                border is Border &&
                border.top.color == exercise.type.color &&
                border.top.width == 2;
          });
          final container = tester.widget<Container>(containerFinder);
          final decoration = container.decoration! as BoxDecoration;

          expect(decoration.color, exercise.type.color.withAlpha(30));
        });
      });
    });
  });

  group('ExerciseCarousel', () {
    group('Given the carousel is rendered', () {
      group('When the card viewport is built', () {
        testWidgets('Then its height is slightly reduced', (tester) async {
          await tester.pumpWidget(buildCarousel());

          expect(
            find.byWidgetPredicate(
              (widget) => widget is SizedBox && widget.height == 160,
            ),
            findsOneWidget,
          );
        });
      });
    });
  });
}
