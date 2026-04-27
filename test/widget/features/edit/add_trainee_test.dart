import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/ui/features/edit/add_trainee.dart';
import 'package:training_organizer/ui/features/email/email_cubit.dart';
import 'package:training_organizer/ui/features/email/email_state.dart';
import 'package:training_organizer/ui/features/overview/selection/filter_trainees_cubit.dart';
import 'package:training_organizer/ui/features/overview/selection/filter_trainees_state.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';

class MockTraineesCubit extends MockCubit<TraineesState>
    implements TraineesCubit {}

class MockEmailCubit extends MockCubit<EmailState> implements EmailCubit {}

class MockFilterTraineesCubit extends MockCubit<FilterTraineesState>
    implements FilterTraineesCubit {}

void main() {
  late MockTraineesCubit mockTraineesCubit;
  late MockEmailCubit mockEmailCubit;
  late MockFilterTraineesCubit mockFilterTraineesCubit;

  setUpAll(() {
    registerFallbackValue(Trainee());
  });

  setUp(() {
    mockTraineesCubit = MockTraineesCubit();
    mockEmailCubit = MockEmailCubit();
    mockFilterTraineesCubit = MockFilterTraineesCubit();

    when(() => mockTraineesCubit.state).thenReturn(TraineesState.initial());
    when(() => mockTraineesCubit.processTrainee(any(), any()))
        .thenAnswer((_) {});
    when(() => mockTraineesCubit.removeTrainee(any())).thenAnswer((_) {});
    when(() => mockTraineesCubit.getNameForGroupEnum(any()))
        .thenReturn('Warteliste');
    when(() => mockEmailCubit.state).thenReturn(EmailState.initial());
    when(() => mockFilterTraineesCubit.state)
        .thenReturn(FilterTraineesState.initial());
  });

  List<BlocProvider> get _providers => [
        BlocProvider<TraineesCubit>.value(value: mockTraineesCubit),
        BlocProvider<EmailCubit>.value(value: mockEmailCubit),
        BlocProvider<FilterTraineesCubit>.value(value: mockFilterTraineesCubit),
      ];

  // Renders AddTrainee as the root (no back button — for UI content tests).
  Widget buildWidget({Trainee? trainee}) {
    return MultiBlocProvider(
      providers: _providers,
      child: MaterialApp(
        home: AddTrainee(trainee: trainee),
      ),
    );
  }

  // Renders AddTrainee as a pushed route (back button visible — for pop tests).
  Widget buildWidgetAsRoute({Trainee? trainee}) {
    return MultiBlocProvider(
      providers: _providers,
      child: MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddTrainee(trainee: trainee)),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
  }

  group('AddTrainee', () {
    group('Given add mode (no trainee)', () {
      group('When the page is rendered', () {
        testWidgets('Then the AppBar title is Hinzufügen', (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(find.widgetWithText(AppBar, 'Hinzufügen'), findsOneWidget);
        });

        testWidgets('Then the Hinzufügen button is shown', (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(
            find.widgetWithText(ElevatedButton, 'Hinzufügen'),
            findsOneWidget,
          );
        });
      });

      group('When Hinzufügen is tapped with valid form input', () {
        testWidgets('Then processTrainee is called with null as old trainee',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          await tester.enterText(
            find.widgetWithText(TextFormField, 'Vorname'),
            'Anna',
          );
          await tester.enterText(
            find.widgetWithText(TextFormField, 'Nachname'),
            'Bauer',
          );
          await tester.pump();

          await tester.ensureVisible(
              find.widgetWithText(ElevatedButton, 'Hinzufügen'));
          await tester.tap(find.widgetWithText(ElevatedButton, 'Hinzufügen'));
          await tester.pump();

          verify(() => mockTraineesCubit.processTrainee(
                null,
                any(
                  that: isA<Trainee>()
                      .having((t) => t.forename, 'forename', 'Anna')
                      .having((t) => t.surname, 'surname', 'Bauer'),
                ),
              )).called(1);
        });
      });
    });

    group('Given edit mode (existing trainee)', () {
      late Trainee existingTrainee;

      setUp(() {
        existingTrainee = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'max@example.com',
          dateOfBirth: '01.01.2000',
          registrationDate: '01.01.2023',
          trainingGroup: Group.waitingList,
        );
      });

      group('When the page is rendered', () {
        testWidgets('Then the AppBar title is Bearbeiten', (tester) async {
          await tester.pumpWidget(buildWidget(trainee: existingTrainee));

          expect(find.widgetWithText(AppBar, 'Bearbeiten'), findsOneWidget);
        });

        testWidgets('Then the form fields are pre-filled with trainee data',
            (tester) async {
          await tester.pumpWidget(buildWidget(trainee: existingTrainee));

          expect(find.widgetWithText(TextFormField, 'Max'), findsOneWidget);
          expect(
              find.widgetWithText(TextFormField, 'Mustermann'), findsOneWidget);
          expect(find.widgetWithText(TextFormField, 'max@example.com'),
              findsOneWidget);
        });
      });

      group('When the user navigates back with valid form data', () {
        testWidgets('Then processTrainee is called with the trainee data',
            (tester) async {
          await tester.pumpWidget(
              buildWidgetAsRoute(trainee: existingTrainee));
          await tester.tap(find.text('Open'));
          await tester.pump(const Duration(milliseconds: 300));

          await tester.tap(find.byType(BackButton));
          await tester.pump();

          verify(() => mockTraineesCubit.processTrainee(
                existingTrainee,
                any(
                  that: isA<Trainee>()
                      .having((t) => t.forename, 'forename', 'Max')
                      .having((t) => t.surname, 'surname', 'Mustermann'),
                ),
              )).called(1);
        });

        testWidgets(
            'Then processTrainee is called with changed data after editing',
            (tester) async {
          await tester.pumpWidget(
              buildWidgetAsRoute(trainee: existingTrainee));
          await tester.tap(find.text('Open'));
          await tester.pump(const Duration(milliseconds: 300));

          await tester.enterText(
            find.widgetWithText(TextFormField, 'Mustermann'),
            'Neumann',
          );
          await tester.pump();

          await tester.tap(find.byType(BackButton));
          await tester.pump();

          verify(() => mockTraineesCubit.processTrainee(
                existingTrainee,
                any(
                  that: isA<Trainee>()
                      .having((t) => t.surname, 'surname', 'Neumann')
                      .having((t) => t.forename, 'forename', 'Max'),
                ),
              )).called(1);
        });
      });

      group(
          'When the user clears a required field and navigates back with invalid form',
          () {
        testWidgets('Then processTrainee is not called', (tester) async {
          await tester.pumpWidget(
              buildWidgetAsRoute(trainee: existingTrainee));
          await tester.tap(find.text('Open'));
          await tester.pump(const Duration(milliseconds: 300));

          await tester.enterText(
            find.widgetWithText(TextFormField, 'Max'),
            '',
          );
          await tester.pump();

          await tester.tap(find.byType(BackButton));
          await tester.pump();

          verifyNever(() => mockTraineesCubit.processTrainee(any(), any()));
        });
      });
    });
  });
}
