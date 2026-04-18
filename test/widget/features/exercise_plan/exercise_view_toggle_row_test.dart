import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_view_toggle_row.dart';

void main() {
  Widget buildWidget() {
    return MaterialApp(
      home: Scaffold(
        body: ExerciseViewToggleRow(
          showListView: false,
          onViewChanged: (_) {},
          onSave: () {},
          onLoad: () {},
          onExport: () {},
          onImport: () {},
        ),
      ),
    );
  }

  group('ExerciseViewToggleRow', () {
    group('Given the toggle row is rendered', () {
      group('When spacing is applied', () {
        testWidgets('Then outer padding matches the design spacing',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Padding &&
                  widget.padding ==
                      const EdgeInsets.only(left: 8, right: 8, top: 8) &&
                  widget.child is Row,
            ),
            findsOneWidget,
          );
        });
      });

      group('When toggle buttons are laid out', () {
        testWidgets('Then they are at the start of the row', (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(find.byType(ToggleButtons), findsOneWidget);
        });
      });
    });
  });
}
