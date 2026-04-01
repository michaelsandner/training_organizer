import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_organizer/data/file_handler.dart';
import 'package:training_organizer/di/service_locator.dart';
import 'package:training_organizer/features/overview/qualification_overlay.dart';
import 'package:training_organizer/features/overview/trainee_list_item.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/main.dart';

import 'helpers/mock_file_exporter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Given app has started', () {
    setUp(() async {
      // Reset the entire GetIt container so each test starts with a clean
      // dependency graph, then re-register all app services via the standard
      // service locator. Finally, swap out the real FileExporter with the
      // test-specific mock that reads from the bundled JSON asset instead of
      // opening a native file picker. allowReassignment lets us overwrite the
      // registration that setupServiceLocator() already created for FileExporter.
      await getIt.reset();
      setupServiceLocator();
      getIt.allowReassignment = true;
      getIt.registerLazySingleton<FileExporter>(
        () => MockTestTraineeFileExporter(),
      );
      getIt.allowReassignment = false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    testWidgets(
      'When open Overview page And import trainees '
      'Then all trainees should be displayed '
      'And group and certificate management works',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        // Use a fixed-duration pump for the initial render so that the
        // repeating ballPulse LoadingIndicator animation (which is shown
        // during file import) never causes pumpAndSettle to hang.
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        // When open Overview page
        // The first tab is Trainingsplan; navigate to the Mitglieder tab.
        await tester.tap(find.text('Mitglieder'));
        await tester.pump(const Duration(milliseconds: 500));

        // With no trainees loaded, NoTraineeDataState is displayed.
        expect(find.text('Keine Mitgliedsdaten geladen'), findsOneWidget);

        // And import trainees — triggers async loading + LoadingIndicator with
        // a continuous ballPulse animation; use a fixed-duration pump to avoid
        // pumpAndSettle hanging on the never-settling animation ticker.
        await tester.tap(find.text('Datei importieren'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 3));

        // Then all trainees should be displayed
        // 20 trainees (2 per group) should be visible with the default "All" filter
        expect(find.byType(TraineeListItem), findsNWidgets(20));

        // When selecting group Aktiv
        await tester.tap(find.byType(DropdownButton<FilterableGroup>));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.tap(find.text('Aktiv').last);
        await tester.pump(const Duration(milliseconds: 500));

        // 2 active trainees should be displayed
        expect(find.byType(TraineeListItem), findsNWidgets(2));

        // And increase the group of one trainee
        // The active trainees are sorted by surname: "AktivA" comes before "AktivB".
        // Tapping the upgrade button of the first item promotes "Anton AktivA"
        // from Aktiv to Freizeit.
        final upgradeButton = find.byIcon(Icons.upgrade_sharp).first;
        await tester.tap(upgradeButton);
        await tester.pump(const Duration(milliseconds: 500));

        // Then the member is displayed in the group Freizeit (leisure).
        // After the upgrade, _changeTraineeGroup automatically switches the
        // filter to the new group (Freizeit), so we expect 3 trainees now:
        // the 2 original leisure trainees plus the newly promoted one.
        expect(find.byType(TraineeListItem), findsNWidgets(3));
        expect(find.textContaining('AktivA'), findsAtLeastNWidgets(1));

        // When opening edit view of this Trainee
        // "AktivA Anton" sorts first (A < F), so the first edit button belongs
        // to the promoted trainee.
        await tester.tap(find.byIcon(Icons.edit).first);
        await tester.pump(const Duration(milliseconds: 500));

        // Verify we are on the edit page for the correct trainee
        expect(find.text('Bearbeiten'), findsOneWidget);

        // And adding a new certificate to the Trainee
        await tester.tap(find.text('Abzeichen hinzufügen'));
        await tester.pump(const Duration(milliseconds: 500));

        // Select "Bronze" (displayed as "Schwimmabzeichen Bronze") in the dialog.
        // The dialog has a DropdownButtonFormField<String> for selecting a qualification.
        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.tap(find.text('Schwimmabzeichen Bronze').last);
        await tester.pump(const Duration(milliseconds: 500));

        // Confirm adding the certificate
        await tester.tap(find.text('Hinzufügen'));
        await tester.pump(const Duration(milliseconds: 500));

        // Then the new certificate is displayed in the edit view
        expect(find.text('Schwimmabzeichen Bronze'), findsOneWidget);

        // Save the trainee changes
        await tester.tap(find.text('Editieren'));
        await tester.pump(const Duration(seconds: 2));

        // Confirm the save dialog
        await tester.tap(find.text('Ja'));
        await tester.pump(const Duration(seconds: 2));

        // Then the new certificate is displayed in the Overview view.
        // We are back on the overview in the Freizeit group.
        // Tap the promoted trainee's row (first item in the list, sorted by surname)
        // to open the QualificationOverlay dialog showing their certifications.
        await tester.tap(find.byType(QualificationOverlay).first);
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Ausbildungen'), findsOneWidget);
        final qualificationDialog = find.byType(AlertDialog);
        expect(
          find.descendant(
            of: qualificationDialog,
            matching: find.byIcon(Icons.check_circle),
          ),
          findsAtLeastNWidgets(1),
        );
      },
    );
  });
}
