import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/performance_data/category_position.dart';
import 'package:training_organizer/ui/features/performance_data/category_position_row.dart';

void main() {
  const categoryPath = [0, 1];
  const positionIndex = 2;
  const position = CategoryPosition(
    anzahl: 3,
    teilnehmende: 'Max Mustermann',
    beschreibung: 'Einsatzleiter',
  );

  Widget buildWidget({
    required void Function(
            List<int> categoryPath, int index, CategoryPosition updated)
        onChanged,
    void Function(List<int> categoryPath, int index)? onRemoved,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: CategoryPositionRow(
          position: position,
          index: positionIndex,
          accentColor: Colors.blue,
          categoryPath: categoryPath,
          onChanged: onChanged,
          onRemoved: onRemoved ?? (_, _) {},
        ),
      ),
    );
  }

  group('CategoryPositionRow', () {
    group('Given a row with initial values', () {
      group('When Teilnehmende is edited and the field loses focus', () {
        testWidgets('Then onChanged is called with the new Teilnehmende value',
            (tester) async {
          CategoryPosition? captured;
          await tester.pumpWidget(buildWidget(
            onChanged: (_, _, updated) => captured = updated,
          ));

          await tester.enterText(
            find.widgetWithText(TextFormField, 'Max Mustermann'),
            'Anna Beispiel',
          );

          // Simulate focus loss by tapping another field (no Enter pressed)
          await tester.tap(find.widgetWithText(TextFormField, 'Einsatzleiter'));
          await tester.pump();

          expect(captured, isNotNull);
          expect(captured!.teilnehmende, 'Anna Beispiel');
        });
      });

      group('When Beschreibung is edited and the field loses focus', () {
        testWidgets('Then onChanged is called with the new Beschreibung value',
            (tester) async {
          CategoryPosition? captured;
          await tester.pumpWidget(buildWidget(
            onChanged: (_, _, updated) => captured = updated,
          ));

          await tester.enterText(
            find.widgetWithText(TextFormField, 'Einsatzleiter'),
            'Sanitäter',
          );

          // Simulate focus loss by tapping another field (no Enter pressed)
          await tester
              .tap(find.widgetWithText(TextFormField, 'Max Mustermann'));
          await tester.pump();

          expect(captured, isNotNull);
          expect(captured!.beschreibung, 'Sanitäter');
        });
      });

      group(
          'When Teilnehmende is edited and the field loses focus without pressing Enter',
          () {
        testWidgets(
            'Then onChanged is called even though Enter was never pressed',
            (tester) async {
          int callCount = 0;
          await tester.pumpWidget(buildWidget(
            onChanged: (_, _, _) => callCount++,
          ));

          await tester.enterText(
            find.widgetWithText(TextFormField, 'Max Mustermann'),
            'Neuer Name',
          );

          // Move focus away — no Enter key
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pump();

          expect(callCount, greaterThan(0));
        });
      });

      group('When Anzahl is edited', () {
        testWidgets('Then onChanged is called immediately with the new Anzahl',
            (tester) async {
          CategoryPosition? captured;
          await tester.pumpWidget(buildWidget(
            onChanged: (_, _, updated) => captured = updated,
          ));

          await tester.enterText(
            // Anzahl is always the first TextFormField in the row
            find.byType(TextFormField).first,
            '7',
          );
          await tester.pump();

          expect(captured, isNotNull);
          expect(captured!.anzahl, 7);
        });
      });

      group('When the remove button is tapped', () {
        testWidgets('Then onRemoved is called with the correct path and index',
            (tester) async {
          List<int>? capturedPath;
          int? capturedIndex;

          await tester.pumpWidget(buildWidget(
            onChanged: (_, _, _) {},
            onRemoved: (path, index) {
              capturedPath = path;
              capturedIndex = index;
            },
          ));

          await tester.tap(find.byIcon(Icons.remove_circle_outline));
          await tester.pump();

          expect(capturedPath, categoryPath);
          expect(capturedIndex, positionIndex);
        });
      });
    });
  });
}
