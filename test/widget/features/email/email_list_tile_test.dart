import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/ui/features/email/email_list_tile.dart';
import 'package:training_organizer/ui/features/email/email_state.dart';

void main() {
  Widget buildTile({required bool isEnabled, required bool isSelected}) {
    return MaterialApp(
      home: Scaffold(
        body: EmailListTile(
          title: 'Test Gruppe',
          group: EmailRecipientGroup.saturdayBlock1,
          isSelected: isSelected,
          isEnabled: isEnabled,
          onChanged: (_) {},
        ),
      ),
    );
  }

  group('EmailListTile', () {
    group('Given isEnabled is true', () {
      group('When the tile is rendered', () {
        testWidgets('Then the checkbox can be interacted with', (tester) async {
          await tester.pumpWidget(
            buildTile(isEnabled: true, isSelected: false),
          );

          final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
          expect(checkbox.onChanged, isNotNull);
        });
      });
    });

    group('Given isEnabled is false', () {
      group('When the tile is rendered', () {
        testWidgets('Then the checkbox is disabled', (tester) async {
          await tester.pumpWidget(
            buildTile(isEnabled: false, isSelected: false),
          );

          final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
          expect(checkbox.onChanged, isNull);
        });
      });
    });
  });
}
