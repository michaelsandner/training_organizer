import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_organizer/data/file_handler.dart';
import 'package:training_organizer/di/service_locator.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_collection_repository.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_cubit.dart';
import 'package:training_organizer/features/overview/qualification_overlay.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_cubit.dart';
import 'package:training_organizer/features/overview/trainee_list.dart';
import 'package:training_organizer/features/overview/trainee_list_item.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/main.dart';

import 'helpers/mock_exercise_collection_file_handler.dart';
import 'helpers/mock_file_exporter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Given app has started', () {
    late MockExerciseCollectionFileHandler mockCollectionFileHandler;

    setUp(() async {
      // Reset the entire GetIt container so each test starts with a clean
      // dependency graph, then re-register all app services via the standard
      // service locator. Finally, swap out the real FileExporter with the
      // test-specific mock that reads from the bundled JSON asset instead of
      // opening a native file picker. allowReassignment lets us overwrite the
      // registration that setupServiceLocator() already created for FileExporter.
      await getIt.reset();
      setupServiceLocator();
      mockCollectionFileHandler = MockExerciseCollectionFileHandler();
      getIt.allowReassignment = true;
      getIt.registerLazySingleton<FileExporter>(
        () => MockTestTraineeFileExporter(),
      );
      getIt.registerLazySingleton<ExerciseCollectionRepository>(
        () => mockCollectionFileHandler,
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
        // 20 trainees (2 per group) should be loaded with the default "All" filter.
        // On smaller screens (like the Android emulator), ListView.builder only
        // mounts visible items + cacheExtent, so we verify the underlying cubit
        // state holds all trainees rather than counting rendered widgets.
        final traineeListContext = tester.element(find.byType(TraineeList));
        final filterCubit =
            BlocProvider.of<FilterTraineesCubit>(traineeListContext);
        expect(filterCubit.state.selectedTrainees.length, 20);
        expect(find.byType(TraineeListItem), findsWidgets);

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
        // On smaller screens the save button may be below the visible viewport
        // inside the SingleChildScrollView, so scroll it into view first.
        await tester.ensureVisible(find.text('Editieren'));
        await tester.pump(const Duration(milliseconds: 500));
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

    testWidgets(
      'When two exercise plans are saved And exported And another plan saved '
      'And exported And imported And loaded '
      'Then the exercise plan is displayed in the swipe view',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        // We are on the Trainingsplan tab by default.
        // Wait for exercises to load.
        await tester.pump(const Duration(seconds: 2));

        // Get the ExercisePlanCubit to read the current plan string.
        final exercisePlanContext =
            tester.element(find.byType(ToggleButtons).first);
        final exercisePlanCubit =
            BlocProvider.of<ExercisePlanCubit>(exercisePlanContext);

        // The default plan should have entries loaded.
        expect(exercisePlanCubit.state.entries.isNotEmpty, true);

        // Record the default plan string for Plan A.
        final planStringA = exercisePlanCubit.state.planString;

        // --- Save Plan A ---
        // Tap the save button (Icons.save).
        await tester.tap(find.byIcon(Icons.save));
        await tester.pump(const Duration(milliseconds: 500));

        // We should be on the save page.
        expect(find.text('Trainingsplan speichern'), findsOneWidget);

        // Enter a name and save.
        await tester.enterText(
            find.byType(TextField).first, 'Plan A');
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Speichern'));
        await tester.pump(const Duration(seconds: 1));

        // Verify Plan A is in the list.
        expect(find.text('Plan A'), findsOneWidget);

        // --- Save Plan B (same plan, different name) ---
        await tester.enterText(
            find.byType(TextField).first, 'Plan B');
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Speichern'));
        await tester.pump(const Duration(seconds: 1));

        // Verify both plans are in the list.
        expect(find.text('Plan A'), findsOneWidget);
        expect(find.text('Plan B'), findsOneWidget);

        // Go back to the exercise plan page.
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pump(const Duration(milliseconds: 500));

        // --- Export collection (with 2 plans) ---
        await tester.tap(find.byIcon(Icons.file_download));
        await tester.pump(const Duration(milliseconds: 500));

        // Enter filename in the export dialog.
        expect(find.text('Trainingspläne exportieren'), findsOneWidget);
        final exportDialog = find.byType(AlertDialog);
        await tester.enterText(
            find.descendant(of: exportDialog, matching: find.byType(TextField)),
            'export_first');
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Exportieren'));
        await tester.pump(const Duration(seconds: 1));

        // Verify the mock stored the export (2 plans).
        expect(mockCollectionFileHandler.lastExportedCollections?.length, 2);

        // --- Save Plan C ---
        await tester.tap(find.byIcon(Icons.save));
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Trainingsplan speichern'), findsOneWidget);

        await tester.enterText(
            find.byType(TextField).first, 'Plan C');
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Speichern'));
        await tester.pump(const Duration(seconds: 1));

        // Verify 3 plans are in the list.
        expect(find.text('Plan A'), findsOneWidget);
        expect(find.text('Plan B'), findsOneWidget);
        expect(find.text('Plan C'), findsOneWidget);

        // Go back.
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pump(const Duration(milliseconds: 500));

        // --- Export collection again (with 3 plans) ---
        await tester.tap(find.byIcon(Icons.file_download));
        await tester.pump(const Duration(milliseconds: 500));
        final exportDialog2 = find.byType(AlertDialog);
        await tester.enterText(
            find.descendant(
                of: exportDialog2, matching: find.byType(TextField)),
            'export_second');
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Exportieren'));
        await tester.pump(const Duration(seconds: 1));

        // The mock now holds the 3-plan export.
        expect(mockCollectionFileHandler.lastExportedCollections?.length, 3);

        // Overwrite the mock's stored export with the first export (2 plans)
        // to simulate importing the first exported file.
        mockCollectionFileHandler.setImportData([
          mockCollectionFileHandler.lastExportedCollections![0],
          mockCollectionFileHandler.lastExportedCollections![1],
        ]);

        // --- Import collection ---
        // Since there are existing plans, the warning dialog should appear.
        await tester.tap(find.byIcon(Icons.file_upload));
        await tester.pump(const Duration(milliseconds: 500));

        // Confirm the import warning.
        expect(find.text('Trainingspläne importieren'), findsOneWidget);
        await tester.tap(find.text('Importieren'));
        await tester.pump(const Duration(seconds: 1));

        // --- Click load button ---
        await tester.tap(find.byIcon(Icons.folder_open));
        await tester.pump(const Duration(milliseconds: 500));

        // We should be on the load page.
        expect(find.text('Trainingsplan laden'), findsOneWidget);

        // Verify 2 plans are displayed (from the first export).
        expect(find.text('Plan A'), findsOneWidget);
        expect(find.text('Plan B'), findsOneWidget);

        // Select Plan A.
        await tester.tap(find.text('Plan A'));
        await tester.pump(const Duration(milliseconds: 500));

        // The load button should now be enabled.
        await tester.ensureVisible(find.text('Laden'));
        await tester.tap(find.text('Laden'));
        await tester.pump(const Duration(seconds: 1));

        // We should be back on the exercise plan page.
        // The plan should have been applied.
        expect(exercisePlanCubit.state.planString, planStringA);
      },
    );
  });
}
