import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_list_item.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_list_view.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_cubit.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_state.dart';

class MockExercisePlanCubit extends MockCubit<ExercisePlanState>
    implements ExercisePlanCubit {}

void main() {
  late MockExercisePlanCubit mockCubit;

  const testExercises = [
    Exercise(
      id: 1,
      name: 'Einschwimmen Strecke',
      description: 'Schwimme x Meter',
      type: ExerciseType.einschwimmen,
      unit: 'Meter',
    ),
    Exercise(
      id: 2,
      name: 'Kraul Beine',
      description: 'Schwimme nur Kraul Beine',
      type: ExerciseType.technikKraul,
      unit: 'Meter',
    ),
    Exercise(
      id: 3,
      name: 'Wasserball',
      description: 'Spiele Wasserball',
      type: ExerciseType.spiel,
      unit: 'Minuten',
    ),
  ];

  setUp(() {
    mockCubit = MockExercisePlanCubit();
    when(() => mockCubit.state).thenReturn(
      const ExercisePlanState(exercises: testExercises),
    );
  });

  Widget buildWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<ExercisePlanCubit>.value(
          value: mockCubit,
          child: const ExerciseListView(),
        ),
      ),
    );
  }

  group('ExerciseListView', () {
    group('Given exercises are loaded', () {
      group('When the list view is rendered', () {
        testWidgets('Then all exercises are displayed', (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(find.text('Einschwimmen Strecke'), findsOneWidget);
          expect(find.text('Kraul Beine'), findsOneWidget);
          expect(find.text('Wasserball'), findsOneWidget);
        });

        testWidgets('Then the type filter dropdown shows Alle by default',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(find.text('Alle'), findsOneWidget);
        });

        testWidgets('Then exercises are grouped by type with headers',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          // Verify type headers are shown (as separate text widgets)
          // 'Einschwimmen' appears as header and in the dropdown
          expect(find.text('Einschwimmen'), findsOneWidget);
          expect(find.text('Technik-Kraul'), findsOneWidget);
          expect(find.text('Spiel'), findsOneWidget);
        });
      });
    });

    group('Given exercises are loaded and all items are shown', () {
      group('When a type filter is selected', () {
        testWidgets('Then only exercises of that type are displayed',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          // Open the dropdown
          await tester.tap(find.text('Alle'));
          await tester.pumpAndSettle();

          // Select "Einschwimmen" type - use last since header also shows it
          await tester.tap(find.text('Einschwimmen').last);
          await tester.pumpAndSettle();

          expect(find.text('Einschwimmen Strecke'), findsOneWidget);
          expect(find.byType(ExerciseListItem), findsOneWidget);
        });

        testWidgets('Then no type headers are displayed', (tester) async {
          await tester.pumpWidget(buildWidget());

          // Open the dropdown
          await tester.tap(find.text('Alle'));
          await tester.pumpAndSettle();

          // Select "Spiel" type
          await tester.tap(find.text('Spiel').last);
          await tester.pumpAndSettle();

          // Only the exercise item, no separate header
          expect(find.byType(ExerciseListItem), findsOneWidget);
          expect(find.text('Wasserball'), findsOneWidget);
        });
      });
    });

    group('Given a type filter is active', () {
      group('When the filter is reset to Alle', () {
        testWidgets('Then all exercises are displayed again', (tester) async {
          await tester.pumpWidget(buildWidget());

          // Select a type filter
          await tester.tap(find.text('Alle'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Einschwimmen').last);
          await tester.pumpAndSettle();

          // Only 1 item visible
          expect(find.byType(ExerciseListItem), findsOneWidget);

          // Open the dropdown again
          await tester
              .tap(find.byType(DropdownButton<ExerciseType?>));
          await tester.pumpAndSettle();

          // Scroll "Alle" into view and select it to reset
          final alleFinder = find.text('Alle').last;
          await tester.ensureVisible(alleFinder);
          await tester.pumpAndSettle();
          await tester.tap(alleFinder);
          await tester.pumpAndSettle();

          expect(find.byType(ExerciseListItem), findsNWidgets(3));
        });
      });
    });

    group('Given no exercises loaded', () {
      group('When the list view is rendered', () {
        testWidgets('Then a loading indicator is displayed', (tester) async {
          when(() => mockCubit.state).thenReturn(
            const ExercisePlanState(exercises: []),
          );

          await tester.pumpWidget(buildWidget());

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });
      });
    });
  });
}
