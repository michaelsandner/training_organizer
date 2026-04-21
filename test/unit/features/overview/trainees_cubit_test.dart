import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/features/overview/trainees_cubit.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_cubit.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_state.dart';

class MockFilterTraineesCubit extends Mock implements FilterTraineesCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(Group.waitingList);
    registerFallbackValue(FilterableGroup.all);
    registerFallbackValue(<Trainee>[]);
  });

  group('TraineesCubit', () {
    late TraineesCubit cubit;
    late TraineesState state;
    late MockFilterTraineesCubit mockFilterTraineesCubit;

    setUp(() {
      mockFilterTraineesCubit = MockFilterTraineesCubit();
      when(() => mockFilterTraineesCubit.state)
          .thenReturn(FilterTraineesState.initial());
      when(() => mockFilterTraineesCubit.setSelectedGroup(any(), any()))
          .thenAnswer((_) {});
      when(() => mockFilterTraineesCubit.getFilteredGroup(any()))
          .thenReturn(FilterableGroup.all);
      cubit = TraineesCubit()..setFilterTraineesCubit(mockFilterTraineesCubit);
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
        blocTest<TraineesCubit, TraineesState>(
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
        blocTest<TraineesCubit, TraineesState>(
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
        blocTest<TraineesCubit, TraineesState>(
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
        blocTest<TraineesCubit, TraineesState>(
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
        blocTest<TraineesCubit, TraineesState>(
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
        blocTest<TraineesCubit, TraineesState>(
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
        blocTest<TraineesCubit, TraineesState>(
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
        blocTest<TraineesCubit, TraineesState>(
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
        blocTest<TraineesCubit, TraineesState>(
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

        blocTest<TraineesCubit, TraineesState>(
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
        blocTest<TraineesCubit, TraineesState>(
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

        blocTest<TraineesCubit, TraineesState>(
          'Then trainee should be replaced in trainee list',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.replaceTrainee(trainee, updatedTrainee),
          expect: () => [
            state.copyWith(trainees: [updatedTrainee]),
          ],
        );
      });

      group('When replaceTrainee with stale old trainee snapshot', () {
        final staleOldTrainee = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          registrationDate: '01.01.2020',
          trainingGroup: Group.group1,
          isMember: true,
        );
        final stateTrainee = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          registrationDate: '01.01.2020',
          trainingGroup: Group.group1,
          isMember: false,
        );
        final updatedTrainee = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          registrationDate: '01.01.2020',
          trainingGroup: Group.group1,
          isMember: true,
        );

        blocTest<TraineesCubit, TraineesState>(
          'Then trainee should still be replaced instead of being duplicated',
          seed: () => state.copyWith(trainees: [stateTrainee]),
          build: () => cubit,
          act: (cubit) => cubit.replaceTrainee(staleOldTrainee, updatedTrainee),
          expect: () => [
            state.copyWith(trainees: [updatedTrainee]),
          ],
        );
      });

      group('When replaceTrainee with stale old trainee snapshot for trainer flag', () {
        final staleOldTrainee = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          registrationDate: '01.01.2020',
          trainingGroup: Group.group1,
          isMember: false,
          isTrainer: false,
        );
        final stateTrainee = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          registrationDate: '01.01.2020',
          trainingGroup: Group.group1,
          isMember: true,
          isTrainer: false,
        );
        final updatedTrainee = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          registrationDate: '01.01.2020',
          trainingGroup: Group.group1,
          isMember: true,
          isTrainer: true,
        );

        blocTest<TraineesCubit, TraineesState>(
          'Then trainee should still be replaced instead of being duplicated',
          seed: () => state.copyWith(trainees: [stateTrainee]),
          build: () => cubit,
          act: (cubit) => cubit.replaceTrainee(staleOldTrainee, updatedTrainee),
          expect: () => [
            state.copyWith(trainees: [updatedTrainee]),
          ],
        );
      });

      group('When replaceTrainee with stale old trainee snapshot and normalized date values', () {
        final staleOldTrainee = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          registrationDate: '2020-01-01',
          trainingGroup: Group.group1,
          isTrainer: false,
        );
        final stateTrainee = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '10.10.2000',
          registrationDate: '01.01.2020',
          trainingGroup: Group.group1,
          isTrainer: false,
        );
        final updatedTrainee = Trainee(
          surname: 'Mustermann',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '10.10.2000',
          registrationDate: '01.01.2020',
          trainingGroup: Group.group1,
          isTrainer: true,
        );

        blocTest<TraineesCubit, TraineesState>(
          'Then trainee should still be replaced instead of being duplicated',
          seed: () => state.copyWith(trainees: [stateTrainee]),
          build: () => cubit,
          act: (cubit) => cubit.replaceTrainee(staleOldTrainee, updatedTrainee),
          expect: () => [
            state.copyWith(trainees: [updatedTrainee]),
          ],
        );
      });
    });

    group('Given FilterTraineesCubit is set', () {
      group('When upgradeTrainee', () {
        test('Then FilterTraineesCubit is updated with new group', () {
          final trainee = Trainee(
            surname: 'Test',
            forename: 'User',
            email: 'test@test.de',
            dateOfBirth: '2000-01-01',
            trainingGroup: Group.waitingList,
          );
          when(() => mockFilterTraineesCubit.getFilteredGroup(Group.invited))
              .thenReturn(FilterableGroup.invited);

          cubit.emit(TraineesState(trainees: [trainee]));
          cubit.upgradeTrainee(trainee);

          verify(() => mockFilterTraineesCubit.setSelectedGroup(
                FilterableGroup.invited,
                any(),
              )).called(1);
        });
      });

      group('When addTrainee', () {
        test('Then FilterTraineesCubit is reset to all', () {
          final trainee = Trainee(
            surname: 'Test',
            forename: 'User',
            email: 'test@test.de',
            dateOfBirth: '2000-01-01',
            trainingGroup: Group.waitingList,
          );

          cubit.addTrainee(trainee);

          verify(() => mockFilterTraineesCubit.setSelectedGroup(
                FilterableGroup.all,
                any(),
              )).called(1);
        });
      });
    });
  });
}
