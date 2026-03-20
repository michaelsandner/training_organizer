import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/email/domain/send_email_usecase.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/overview/selection/selection_cubit.dart';
import 'package:training_organizer/overview/selection/selection_state.dart';

class MockSendEmailUseCase extends Mock implements SendEmailUseCase {}

class MockSelectionCubit extends Mock implements SelectionCubit {}

void main() {
  group('AppCubit', () {
    late AppCubit cubit;
    late AppState state;
    late MockSendEmailUseCase mockSendEmailUseCase;
    late MockSelectionCubit mockSelectionCubit;

    setUp(() {
      mockSendEmailUseCase = MockSendEmailUseCase();
      mockSelectionCubit = MockSelectionCubit();
      when(() => mockSelectionCubit.state).thenReturn(SelectionState.initial());
      when(() => mockSelectionCubit.setSelectedGroup(any(), any()))
          .thenAnswer((_) {});
      when(() => mockSelectionCubit.getFilteredGroup(any()))
          .thenReturn(FilterableGroup.all);
      cubit = AppCubit(mockSendEmailUseCase)
        ..setSelectionCubit(mockSelectionCubit);
    });

    group('Given trainee in waitingList', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.waitingList,
        );
        state = cubit.state.copyWith(trainees: [trainee]);
      });

      group('When upgradeTrainee', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be updated to group invited',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.upgradeTrainee(trainee),
          expect: () => [
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.invited,
                ),
              ],
            ),
          ],
        );
      });

      group('When upgradeTrainee twice', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be updated to group 5',
          seed: () => state,
          build: () => cubit,
          act: (cubit) {
            cubit.upgradeTrainee(trainee);
            cubit.upgradeTrainee(trainee.copyWithNewGroup(Group.invited));
          },
          expect: () => [
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.invited,
                ),
              ],
            ),
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group5,
                ),
              ],
            ),
          ],
        );
      });

      group('When addTrainee with same trainee', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should not be added to trainee list',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.addTrainee(trainee),
          expect: () => [],
        );
      });
    });

    group('Given trainee in Group 5', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.group5,
        );
        state = cubit.state.copyWith(trainees: [trainee]);
      });

      group('When upgradeTrainee', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be updated to group 1',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.upgradeTrainee(trainee),
          expect: () => [
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group1,
                ),
              ],
            ),
          ],
        );
      });
    });

    group('Given trainee in Group 1', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.group1,
        );
        state = cubit.state.copyWith(trainees: [trainee]);
      });

      group('When upgradeTrainee', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be updated to group 2',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.upgradeTrainee(trainee),
          expect: () => [
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group2,
                ),
              ],
            ),
          ],
        );
      });
    });

    group('Given trainee in Group 2', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.group2,
        );
        state = cubit.state.copyWith(trainees: [trainee]);
      });

      group('When upgradeTrainee', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be updated to group 4',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.upgradeTrainee(trainee),
          expect: () => [
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group4,
                ),
              ],
            ),
          ],
        );
      });
    });

    group('Given trainee in Group 4', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.group4,
        );
        state = cubit.state.copyWith(trainees: [trainee]);
      });

      group('When upgradeTrainee', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be updated to group 3',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.upgradeTrainee(trainee),
          expect: () => [
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group3,
                ),
              ],
            ),
          ],
        );
      });
    });

    group('Given trainee in Group 3', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.group3,
        );
        state = cubit.state.copyWith(trainees: [trainee]);
      });

      group('When upgradeTrainee', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be updated to group wednesday',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.upgradeTrainee(trainee),
          expect: () => [
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.wednesday,
                ),
              ],
            ),
          ],
        );
      });
    });

    group('Given trainee in Group wednesday', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.wednesday,
        );
        state = cubit.state.copyWith(trainees: [trainee]);
      });

      group('When upgradeTrainee', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be updated to group active',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.upgradeTrainee(trainee),
          expect: () => [
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.active,
                ),
              ],
            ),
          ],
        );
      });
    });

    group('Given trainee does not exist in trainee list', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.waitingList,
        );
        state = cubit.state.copyWith(trainees: [trainee]);
      });

      group('When addTrainee', () {
        final newTrainee = Trainee(
          surname: 'Musterfrau',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.waitingList,
        );

        blocTest<AppCubit, AppState>(
          'Then trainee should be added to trainee list',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.addTrainee(newTrainee),
          expect: () => [
            state.copyWith(
              trainees: [trainee, newTrainee],
            ),
          ],
        );
      });
    });

    group('Given trainee is leisure group', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.leisure,
        );
      });

      group('When isUpgradePossible', () {
        test('Then upgrade should not be possible', () {
          expect(cubit.isUpgradePossible(trainee), false);
        });
      });
    });

    group('Given trainee is in waitingList', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.waitingList,
        );
      });

      group('When isDowngradePossible', () {
        test('Then downgrade should not be possible', () {
          expect(cubit.isDowngradePossible(trainee), false);
        });
      });
    });

    group('Given trainee is in group5', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.group5,
        );
      });

      group('When isDowngradePossible', () {
        test('Then downgrade should not be possible', () {
          expect(cubit.isDowngradePossible(trainee), false);
        });
      });
    });

    group('Given trainee in group1', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.group1,
        );
        state = cubit.state.copyWith(trainees: [trainee]);
      });

      group('When removeTrainee', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be removed from trainee list',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.removeTrainee(trainee),
          expect: () => [
            state.copyWith(trainees: const []),
          ],
        );
      });

      group('When replaceTrainee', () {
        final updatedTrainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'updated@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: Group.group1,
        );

        blocTest<AppCubit, AppState>(
          'Then trainee should be replaced in trainee list',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.replaceTrainee(trainee, updatedTrainee),
          expect: () => [
            state.copyWith(trainees: [updatedTrainee]),
          ],
        );
      });
    });

    group('Given SelectionCubit is set', () {
      group('When upgradeTrainee', () {
        test('Then SelectionCubit is updated with new group', () {
          final trainee = Trainee(
            surname: 'Test',
            forename: 'User',
            email: 'test@test.de',
            dateOfBirth: '2000-01-01',
            trainingGroup: Group.waitingList,
          );
          when(() => mockSelectionCubit.getFilteredGroup(Group.invited))
              .thenReturn(FilterableGroup.invited);

          cubit.emit(AppState(trainees: [trainee]));
          cubit.upgradeTrainee(trainee);

          verify(() => mockSelectionCubit.setSelectedGroup(
                FilterableGroup.invited,
                any(),
              )).called(1);
        });
      });

      group('When addTrainee', () {
        test('Then SelectionCubit is reset to all', () {
          final trainee = Trainee(
            surname: 'Test',
            forename: 'User',
            email: 'test@test.de',
            dateOfBirth: '2000-01-01',
            trainingGroup: Group.waitingList,
          );

          cubit.addTrainee(trainee);

          verify(() => mockSelectionCubit.setSelectedGroup(
                FilterableGroup.all,
                any(),
              )).called(1);
        });
      });
    });
  });
}
