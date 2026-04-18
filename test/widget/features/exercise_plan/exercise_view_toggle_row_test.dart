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
        testWidgets('Then they are positioned at the start of the row',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          final toggleLeft = tester.getTopLeft(find.byType(ToggleButtons)).dx;

          // The toggle should be near the left edge (after 8px padding).
          expect(toggleLeft, closeTo(8.0, 1.0));
        });
      });

      group('When action buttons are rendered', () {
        testWidgets('Then save, load, export, and import icons are shown',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(find.byIcon(Icons.save), findsOneWidget);
          expect(find.byIcon(Icons.folder_open), findsOneWidget);
          expect(find.byIcon(Icons.file_download), findsOneWidget);
          expect(find.byIcon(Icons.file_upload), findsOneWidget);
        });
      });
    });
  });
}
