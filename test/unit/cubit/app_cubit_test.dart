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
          trainingGroup: Group.waitingList,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: Group.waitingList,
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
                  trainingGroup: Group.group5,
                ),
              ],
              selectedGroup: Group.waitingList,
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
                selectedGroup: Group.group5,
                selectedTrainees: [
                  Trainee(
                    surname: 'Musterman',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: Group.group5,
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
            cubit.upgradeTrainee(trainee.copyWithNewGroup(Group.group5));
          },
          expect: () => [
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
              selectedGroup: Group.waitingList,
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
              selectedGroup: Group.group5,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group5,
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
                    trainingGroup: Group.group1,
                  ),
                ],
                selectedGroup: Group.group5,
                selectedTrainees: [
                  Trainee(
                    surname: 'Musterman',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: Group.group5,
                  )
                ]),
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
              selectedGroup: Group.group1,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group1,
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
          trainingGroup: Group.waitingList,
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
          trainingGroup: Group.group5,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: Group.group5,
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
                  trainingGroup: Group.group1,
                ),
              ],
              selectedGroup: Group.group5,
            ),
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
              selectedGroup: Group.group1,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group1,
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
          trainingGroup: Group.group1,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: Group.group1,
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
                  trainingGroup: Group.group2,
                ),
              ],
              selectedGroup: Group.group1,
            ),
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
              selectedGroup: Group.group2,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group2,
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
          trainingGroup: Group.group2,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: Group.group2,
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
                  trainingGroup: Group.group4,
                ),
              ],
              selectedGroup: Group.group2,
            ),
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
              selectedGroup: Group.group4,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group4,
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
          trainingGroup: Group.group4,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: Group.group4,
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
                  trainingGroup: Group.group3,
                ),
              ],
              selectedGroup: Group.group4,
            ),
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
              selectedGroup: Group.group3,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.group3,
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
          trainingGroup: Group.group3,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: Group.group3,
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
                  trainingGroup: Group.wednesday,
                ),
              ],
              selectedGroup: Group.group3,
            ),
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
              selectedGroup: Group.wednesday,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.wednesday,
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
          trainingGroup: Group.wednesday,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: Group.wednesday,
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
                  trainingGroup: Group.active,
                ),
              ],
              selectedGroup: Group.wednesday,
            ),
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
              selectedGroup: Group.active,
              selectedTrainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.active,
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
          trainingGroup: Group.waitingList,
        );
        state = cubit.state.copyWith(
          trainees: [trainee],
          selectedGroup: Group.all,
          selectedTrainees: List<Trainee>.empty(),
        );
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
              trainees: [
                Trainee(
                  surname: 'Musterman',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.waitingList,
                ),
                Trainee(
                  surname: 'Musterfrau',
                  forename: 'Max',
                  email: 'email@email.de',
                  dateOfBirth: '2000-10-10',
                  trainingGroup: Group.waitingList,
                ),
              ],
              selectedGroup: Group.all,
            ),
            state.copyWith(
                trainees: [
                  Trainee(
                    surname: 'Musterman',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: Group.waitingList,
                  ),
                  Trainee(
                    surname: 'Musterfrau',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: Group.waitingList,
                  ),
                ],
                selectedGroup: Group.all,
                selectedTrainees: [
                  Trainee(
                    surname: 'Musterman',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: Group.waitingList,
                  ),
                  Trainee(
                    surname: 'Musterfrau',
                    forename: 'Max',
                    email: 'email@email.de',
                    dateOfBirth: '2000-10-10',
                    trainingGroup: Group.waitingList,
                  ),
                ]),
          ],
        );
      });
    });
  });
}
