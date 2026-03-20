import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/overview/selection/selection_cubit.dart';
import 'package:training_organizer/overview/selection/selection_state.dart';

void main() {
  group('SelectionCubit', () {
    late SelectionCubit cubit;

    setUp(() {
      cubit = SelectionCubit();
    });

    group('Given a list of trainees from different groups', () {
      final waitingListTrainee = Trainee(
        surname: 'Beta',
        forename: 'Max',
        email: 'beta@email.de',
        dateOfBirth: '2000-10-10',
        registrationDate: '2023-02-01',
        trainingGroup: Group.waitingList,
      );
      final group1Trainee = Trainee(
        surname: 'Alpha',
        forename: 'Anna',
        email: 'alpha@email.de',
        dateOfBirth: '1995-05-05',
        trainingGroup: Group.group1,
      );
      final group2Trainee = Trainee(
        surname: 'Gamma',
        forename: 'Karl',
        email: 'gamma@email.de',
        dateOfBirth: '1998-03-15',
        trainingGroup: Group.group2,
      );

      final allTrainees = [waitingListTrainee, group1Trainee, group2Trainee];

      group('When setSelectedGroup with FilterableGroup.all', () {
        blocTest<SelectionCubit, SelectionState>(
          'Then all trainees are selected',
          build: () => cubit,
          act: (cubit) =>
              cubit.setSelectedGroup(FilterableGroup.all, allTrainees),
          expect: () => [
            SelectionState.initial().copyWith(
              selectedGroup: FilterableGroup.all,
              selectedTrainees: allTrainees,
            ),
          ],
        );
      });

      group('When setSelectedGroup with null', () {
        blocTest<SelectionCubit, SelectionState>(
          'Then all trainees are selected with group set to all',
          build: () => cubit,
          act: (cubit) => cubit.setSelectedGroup(null, allTrainees),
          expect: () => [
            SelectionState.initial().copyWith(
              selectedGroup: FilterableGroup.all,
              selectedTrainees: allTrainees,
            ),
          ],
        );
      });

      group('When setSelectedGroup with FilterableGroup.group1', () {
        blocTest<SelectionCubit, SelectionState>(
          'Then only group1 trainees are selected',
          build: () => cubit,
          act: (cubit) =>
              cubit.setSelectedGroup(FilterableGroup.group1, allTrainees),
          expect: () => [
            SelectionState.initial().copyWith(
              selectedGroup: FilterableGroup.group1,
              selectedTrainees: [group1Trainee],
            ),
          ],
        );
      });

      group('When setSelectedGroup with FilterableGroup.waitingList', () {
        blocTest<SelectionCubit, SelectionState>(
          'Then only waitingList trainees are selected',
          build: () => cubit,
          act: (cubit) =>
              cubit.setSelectedGroup(FilterableGroup.waitingList, allTrainees),
          expect: () => [
            SelectionState.initial().copyWith(
              selectedGroup: FilterableGroup.waitingList,
              selectedTrainees: [waitingListTrainee],
            ),
          ],
        );
      });
    });

    group('Given multiple trainees in same group with different surnames', () {
      final traineeC = Trainee(
        surname: 'Zimmermann',
        forename: 'Karl',
        email: 'c@email.de',
        dateOfBirth: '2000-01-01',
        trainingGroup: Group.group1,
      );
      final traineeA = Trainee(
        surname: 'Auer',
        forename: 'Anna',
        email: 'a@email.de',
        dateOfBirth: '2000-01-01',
        trainingGroup: Group.group1,
      );
      final traineeB = Trainee(
        surname: 'Meier',
        forename: 'Max',
        email: 'b@email.de',
        dateOfBirth: '2000-01-01',
        trainingGroup: Group.group1,
      );

      final allTrainees = [traineeC, traineeA, traineeB];

      group('When setSelectedGroup with non-waitingList group', () {
        blocTest<SelectionCubit, SelectionState>(
          'Then trainees are sorted by surname',
          build: () => cubit,
          act: (cubit) =>
              cubit.setSelectedGroup(FilterableGroup.group1, allTrainees),
          expect: () => [
            SelectionState.initial().copyWith(
              selectedGroup: FilterableGroup.group1,
              selectedTrainees: [traineeA, traineeB, traineeC],
            ),
          ],
        );
      });
    });

    group('Given multiple trainees in waitingList with different registration dates',
        () {
      final traineeFirst = Trainee(
        surname: 'Zweiter',
        forename: 'Max',
        email: 'second@email.de',
        dateOfBirth: '2000-01-01',
        registrationDate: '2023-01-01',
        trainingGroup: Group.waitingList,
      );
      final traineeSecond = Trainee(
        surname: 'Erster',
        forename: 'Anna',
        email: 'first@email.de',
        dateOfBirth: '2000-01-01',
        registrationDate: '2022-06-15',
        trainingGroup: Group.waitingList,
      );
      final traineeThird = Trainee(
        surname: 'Dritter',
        forename: 'Karl',
        email: 'third@email.de',
        dateOfBirth: '2000-01-01',
        registrationDate: '2023-05-20',
        trainingGroup: Group.waitingList,
      );

      final allTrainees = [traineeFirst, traineeSecond, traineeThird];

      group('When setSelectedGroup with FilterableGroup.waitingList', () {
        blocTest<SelectionCubit, SelectionState>(
          'Then trainees are sorted by registration date',
          build: () => cubit,
          act: (cubit) =>
              cubit.setSelectedGroup(FilterableGroup.waitingList, allTrainees),
          expect: () => [
            SelectionState.initial().copyWith(
              selectedGroup: FilterableGroup.waitingList,
              selectedTrainees: [traineeSecond, traineeFirst, traineeThird],
            ),
          ],
        );
      });
    });

    group('Given group conversion methods', () {
      group('When getFilteredGroup', () {
        test('Then each Group maps to the correct FilterableGroup', () {
          expect(cubit.getFilteredGroup(Group.waitingList),
              FilterableGroup.waitingList);
          expect(cubit.getFilteredGroup(Group.invited), FilterableGroup.invited);
          expect(cubit.getFilteredGroup(Group.group1), FilterableGroup.group1);
          expect(cubit.getFilteredGroup(Group.group2), FilterableGroup.group2);
          expect(cubit.getFilteredGroup(Group.group3), FilterableGroup.group3);
          expect(cubit.getFilteredGroup(Group.group4), FilterableGroup.group4);
          expect(cubit.getFilteredGroup(Group.group5), FilterableGroup.group5);
          expect(
              cubit.getFilteredGroup(Group.wednesday), FilterableGroup.wednesday);
          expect(cubit.getFilteredGroup(Group.active), FilterableGroup.active);
          expect(cubit.getFilteredGroup(Group.leisure), FilterableGroup.leisure);
        });
      });

      group('When getGroup', () {
        test('Then each FilterableGroup maps to the correct Group', () {
          expect(
              cubit.getGroup(FilterableGroup.waitingList), Group.waitingList);
          expect(cubit.getGroup(FilterableGroup.invited), Group.invited);
          expect(cubit.getGroup(FilterableGroup.group1), Group.group1);
          expect(cubit.getGroup(FilterableGroup.group2), Group.group2);
          expect(cubit.getGroup(FilterableGroup.group3), Group.group3);
          expect(cubit.getGroup(FilterableGroup.group4), Group.group4);
          expect(cubit.getGroup(FilterableGroup.group5), Group.group5);
          expect(cubit.getGroup(FilterableGroup.wednesday), Group.wednesday);
          expect(cubit.getGroup(FilterableGroup.active), Group.active);
          expect(cubit.getGroup(FilterableGroup.leisure), Group.leisure);
        });
      });
    });

    group('Given name utility methods', () {
      group('When getNameForFilteredGroupEnum with null', () {
        test('Then returns All', () {
          expect(cubit.getNameForFilteredGroupEnum(null), 'All');
        });
      });

      group('When getNameForFilteredGroupEnum with FilterableGroup.all', () {
        test('Then returns All', () {
          expect(
              cubit.getNameForFilteredGroupEnum(FilterableGroup.all), 'All');
        });
      });

      group(
          'When getNameForFilteredGroupEnum with FilterableGroup.waitingList',
          () {
        test('Then returns correct German name', () {
          expect(
              cubit.getNameForFilteredGroupEnum(FilterableGroup.waitingList),
              'Warteliste');
        });
      });

      group('When getSelectedGroupName with initial state', () {
        test('Then returns All', () {
          expect(cubit.getSelectedGroupName(), 'All');
        });
      });
    });
  });
}
