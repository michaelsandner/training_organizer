import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/ui/features/email/email_cubit.dart';
import 'package:training_organizer/ui/features/email/email_state.dart';
import 'package:training_organizer/ui/features/email/send_button.dart';
import 'package:training_organizer/ui/features/overview/trainees_cubit.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';

class MockTraineesCubit extends MockCubit<TraineesState>
    implements TraineesCubit {}

class MockEmailCubit extends MockCubit<EmailState> implements EmailCubit {}

void main() {
  late MockTraineesCubit mockTraineesCubit;
  late MockEmailCubit mockEmailCubit;

  setUp(() {
    mockTraineesCubit = MockTraineesCubit();
    mockEmailCubit = MockEmailCubit();
  });

  Widget buildWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TraineesCubit>.value(value: mockTraineesCubit),
        BlocProvider<EmailCubit>.value(value: mockEmailCubit),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SendButton(),
        ),
      ),
    );
  }

  group('SendButton', () {
    group('Given no trainees are available', () {
      setUp(() {
        when(() => mockTraineesCubit.state)
            .thenReturn(const TraineesState(trainees: []));
        when(() => mockEmailCubit.state).thenReturn(EmailState.initial());
      });

      group('When the button is rendered', () {
        testWidgets(
            'Then it shows the info text about missing email addresses',
            (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(
            find.text(
              'Keine E-Mail Adressen verfügbar. Bitte Mitglieder importieren.',
            ),
            findsOneWidget,
          );
        });

        testWidgets('Then the send button is disabled', (tester) async {
          await tester.pumpWidget(buildWidget());

          final button =
              tester.widget<ElevatedButton>(find.byType(ElevatedButton));
          expect(button.onPressed, isNull);
        });
      });
    });

    group('Given trainees are available but no group is selected', () {
      setUp(() {
        when(() => mockTraineesCubit.state).thenReturn(
          TraineesState(
            trainees: [Trainee(email: 'test@example.com')],
          ),
        );
        when(() => mockEmailCubit.state).thenReturn(EmailState.initial());
      });

      group('When the button is rendered', () {
        testWidgets('Then the info text is not shown', (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(
            find.text(
              'Keine E-Mail Adressen verfügbar. Bitte Mitglieder importieren.',
            ),
            findsNothing,
          );
        });

        testWidgets('Then the send button is disabled', (tester) async {
          await tester.pumpWidget(buildWidget());

          final button =
              tester.widget<ElevatedButton>(find.byType(ElevatedButton));
          expect(button.onPressed, isNull);
        });
      });
    });

    group('Given trainees are available and a group is selected', () {
      setUp(() {
        when(() => mockTraineesCubit.state).thenReturn(
          TraineesState(
            trainees: [Trainee(email: 'test@example.com')],
          ),
        );
        when(() => mockEmailCubit.state).thenReturn(
          const EmailState(
            selectedGroups: {EmailRecipientGroup.saturdayBlock1},
          ),
        );
      });

      group('When the button is rendered', () {
        testWidgets('Then the info text is not shown', (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(
            find.text(
              'Keine E-Mail Adressen verfügbar. Bitte Mitglieder importieren.',
            ),
            findsNothing,
          );
        });

        testWidgets('Then the send button is enabled', (tester) async {
          await tester.pumpWidget(buildWidget());

          final button =
              tester.widget<ElevatedButton>(find.byType(ElevatedButton));
          expect(button.onPressed, isNotNull);
        });
      });
    });
  });
}
