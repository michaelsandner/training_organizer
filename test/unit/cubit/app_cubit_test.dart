import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  group('AppCubit', () {
    late AppCubit cubit;
    late AppState state;

    setUp(() {
      cubit = AppCubit();
    });
    group('Given trainee in waitingslist', () {
      late Trainee trainee;
      setUp(() {
        trainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: FilterableGroup.waitingList,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: FilterableGroup.waitingList,
          selectedTrainees: List<Trainee>.empty(),
        );
      });
      group('When updateTrainee', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be updated to group 5',
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
                  trainingGroup: FilterableGroup.group5,
                ),
              ],
              selectedGroup: FilterableGroup.waitingList,
            ),
            state.copyWith(
                trainees: [
                  Trainee(
                    surname: 'Musterman',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: FilterableGroup.group5,
                  ),
                ],
                selectedGroup: FilterableGroup.group5,
                selectedTrainees: [
                  Trainee(
                    surname: 'Musterman',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: FilterableGroup.group5,
                  )
                ])
          ],
        );
      });
      group('When updateTrainee twice', () {
        blocTest<AppCubit, AppState>(
          'Then trainee should be updated to group 1',
          seed: () => state,
          build: () => cubit,
          act: (cubit) {
            cubit.upgradeTrainee(trainee);
            cubit.upgradeTrainee(
                trainee.copyWithNewGroup(FilterableGroup.group5));
          },
          expect: () => [
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group5,
                ),
              ],
              selectedGroup: FilterableGroup.waitingList,
            ),
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group5,
                ),
              ],
              selectedGroup: FilterableGroup.group5,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group5,
                )
              ],
            ),
            state.copyWith(
                trainees: [
                  Trainee(
                    surname: 'Musterman',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: FilterableGroup.group1,
                  ),
                ],
                selectedGroup: FilterableGroup.group5,
                selectedTrainees: [
                  Trainee(
                    surname: 'Musterman',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: FilterableGroup.group5,
                  )
                ]),
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group1,
                ),
              ],
              selectedGroup: FilterableGroup.group1,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group1,
                )
              ],
            )
          ],
        );
      });

      group('When addTrainee', () {
        final newTrainee = Trainee(
          surname: 'Musterman',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: FilterableGroup.waitingList,
        );
        blocTest<AppCubit, AppState>(
          'Then trainee should not be added to trainee list',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.addTrainee(newTrainee),
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
          trainingGroup: FilterableGroup.group5,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: FilterableGroup.group5,
          selectedTrainees: List<Trainee>.empty(),
        );
      });
      group('When updateTrainee', () {
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
                  trainingGroup: FilterableGroup.group1,
                ),
              ],
              selectedGroup: FilterableGroup.group5,
            ),
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group1,
                ),
              ],
              selectedGroup: FilterableGroup.group1,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group1,
                )
              ],
            )
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
          trainingGroup: FilterableGroup.group1,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: FilterableGroup.group1,
          selectedTrainees: List<Trainee>.empty(),
        );
      });
      group('When updateTrainee', () {
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
                  trainingGroup: FilterableGroup.group2,
                ),
              ],
              selectedGroup: FilterableGroup.group1,
            ),
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group2,
                ),
              ],
              selectedGroup: FilterableGroup.group2,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group2,
                )
              ],
            )
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
          trainingGroup: FilterableGroup.group2,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: FilterableGroup.group2,
          selectedTrainees: List<Trainee>.empty(),
        );
      });
      group('When updateTrainee', () {
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
                  trainingGroup: FilterableGroup.group4,
                ),
              ],
              selectedGroup: FilterableGroup.group2,
            ),
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group4,
                ),
              ],
              selectedGroup: FilterableGroup.group4,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group4,
                )
              ],
            )
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
          trainingGroup: FilterableGroup.group4,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: FilterableGroup.group4,
          selectedTrainees: List<Trainee>.empty(),
        );
      });
      group('When updateTrainee', () {
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
                  trainingGroup: FilterableGroup.group3,
                ),
              ],
              selectedGroup: FilterableGroup.group4,
            ),
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group3,
                ),
              ],
              selectedGroup: FilterableGroup.group3,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.group3,
                )
              ],
            )
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
          trainingGroup: FilterableGroup.group3,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: FilterableGroup.group3,
          selectedTrainees: List<Trainee>.empty(),
        );
      });
      group('When updateTrainee', () {
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
                  trainingGroup: FilterableGroup.wednesday,
                ),
              ],
              selectedGroup: FilterableGroup.group3,
            ),
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.wednesday,
                ),
              ],
              selectedGroup: FilterableGroup.wednesday,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.wednesday,
                )
              ],
            )
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
          trainingGroup: FilterableGroup.wednesday,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: FilterableGroup.wednesday,
          selectedTrainees: List<Trainee>.empty(),
        );
      });
      group('When updateTrainee', () {
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
                  trainingGroup: FilterableGroup.active,
                ),
              ],
              selectedGroup: FilterableGroup.wednesday,
            ),
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.active,
                ),
              ],
              selectedGroup: FilterableGroup.active,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.active,
                )
              ],
            )
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
          trainingGroup: FilterableGroup.waitingList,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: FilterableGroup.all,
          selectedTrainees: List<Trainee>.empty(),
        );
      });
      group('When addTrainee', () {
        final newTrainee = Trainee(
          surname: 'Musterfrau',
          forename: 'Max',
          email: 'email@email.de',
          dateOfBirth: '2000-10-10',
          trainingGroup: FilterableGroup.waitingList,
        );
        blocTest<AppCubit, AppState>(
          'Then trainee should be added to trainee list',
          seed: () => state,
          build: () => cubit,
          act: (cubit) => cubit.addTrainee(newTrainee),
          expect: () => [
            state.copyWith(
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.waitingList,
                ),
                Trainee(
                  surname: 'Musterfrau',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: FilterableGroup.waitingList,
                ),
              ],
              selectedGroup: FilterableGroup.all,
            ),
            state.copyWith(
                trainees: [
                  Trainee(
                    surname: 'Musterman',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: FilterableGroup.waitingList,
                  ),
                  Trainee(
                    surname: 'Musterfrau',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: FilterableGroup.waitingList,
                  ),
                ],
                selectedGroup: FilterableGroup.all,
                selectedTrainees: [
                  Trainee(
                    surname: 'Musterman',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: FilterableGroup.waitingList,
                  ),
                  Trainee(
                    surname: 'Musterfrau',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: FilterableGroup.waitingList,
                  ),
                ]),
          ],
        );
      });
    });
  });
}
