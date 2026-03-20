import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/cubit/trainees_cubit.dart';
import 'package:training_organizer/cubit/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/data/local_storage_repository.dart';
import 'package:training_organizer/overview/selection/filter_trainees_cubit.dart';
import 'package:training_organizer/overview/selection/filter_trainees_state.dart';


class MockLocalStorageRepository extends Mock
    implements LocalStorageRepository {}

class MockFilterTraineesCubit extends Mock implements FilterTraineesCubit {}

void main() {
  late MockLocalStorageRepository mockLocalStorage;
  late MockFilterTraineesCubit mockFilterTraineesCubit;

  final trainee = Trainee(
    surname: 'Muster',
    forename: 'Max',
    email: 'max@example.de',
    dateOfBirth: '2000-01-01',
    trainingGroup: Group.group1,
  );

  setUp(() {
    mockLocalStorage = MockLocalStorageRepository();
    mockFilterTraineesCubit = MockFilterTraineesCubit();

    when(() => mockLocalStorage.saveTrainees(any()))
        .thenAnswer((_) async {});
    when(() => mockLocalStorage.loadTrainees())
        .thenAnswer((_) async => null);
    when(() => mockFilterTraineesCubit.state).thenReturn(FilterTraineesState.initial());
    when(() => mockFilterTraineesCubit.setSelectedGroup(any(), any()))
        .thenAnswer((_) {});
    when(() => mockFilterTraineesCubit.getFilteredGroup(any()))
        .thenReturn(FilterableGroup.all);
  });

  group('TraineesCubit with LocalStorage', () {
    group('Given local storage has saved trainees', () {
      setUp(() {
        when(() => mockLocalStorage.loadTrainees())
            .thenAnswer((_) async => [trainee]);
      });

      group('When init is called', () {
        blocTest<TraineesCubit, TraineesState>(
          'Then trainees are loaded from local storage',
          build: () => TraineesCubit(localStorageRepository: mockLocalStorage,
          )..setFilterTraineesCubit(mockFilterTraineesCubit),
          act: (cubit) => cubit.init(),
          expect: () => [
            TraineesState.initial().copyWith(
              trainees: [trainee],
            ),
          ],
        );
      });
    });

    group('Given local storage is empty', () {
      group('When init is called', () {
        blocTest<TraineesCubit, TraineesState>(
          'Then state remains unchanged',
          build: () => TraineesCubit(localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.init(),
          expect: () => [],
        );
      });
    });

    group('Given a cubit with local storage', () {
      group('When updateTraineeList is called', () {
        blocTest<TraineesCubit, TraineesState>(
          'Then trainees are saved to local storage',
          build: () => TraineesCubit(localStorageRepository: mockLocalStorage,
          )..setFilterTraineesCubit(mockFilterTraineesCubit),
          act: (cubit) => cubit.updateTraineeList([trainee]),
          verify: (_) {
            verify(() => mockLocalStorage.saveTrainees([trainee])).called(1);
          },
        );
      });

      group('When addTrainee is called', () {
        blocTest<TraineesCubit, TraineesState>(
          'Then trainees are saved to local storage',
          build: () => TraineesCubit(localStorageRepository: mockLocalStorage,
          )..setFilterTraineesCubit(mockFilterTraineesCubit),
          act: (cubit) => cubit.addTrainee(trainee),
          verify: (_) {
            verify(() => mockLocalStorage.saveTrainees([trainee])).called(1);
          },
        );
      });

      group('When removeTrainee is called', () {
        blocTest<TraineesCubit, TraineesState>(
          'Then trainees are saved to local storage',
          seed: () => TraineesState.initial().copyWith(
            trainees: [trainee],
          ),
          build: () => TraineesCubit(localStorageRepository: mockLocalStorage,
          )..setFilterTraineesCubit(mockFilterTraineesCubit),
          act: (cubit) => cubit.removeTrainee(trainee),
          verify: (_) {
            verify(() => mockLocalStorage.saveTrainees([])).called(1);
          },
        );
      });

      group('When replaceTrainee is called', () {
        final updatedTrainee = Trainee(
          surname: 'Muster',
          forename: 'Max',
          email: 'updated@example.de',
          dateOfBirth: '2000-01-01',
          trainingGroup: Group.group1,
        );

        blocTest<TraineesCubit, TraineesState>(
          'Then updated trainees are saved to local storage',
          seed: () => TraineesState.initial().copyWith(
            trainees: [trainee],
          ),
          build: () => TraineesCubit(localStorageRepository: mockLocalStorage,
          )..setFilterTraineesCubit(mockFilterTraineesCubit),
          act: (cubit) => cubit.replaceTrainee(trainee, updatedTrainee),
          verify: (_) {
            verify(() =>
                    mockLocalStorage.saveTrainees([updatedTrainee]))
                .called(1);
          },
        );
      });

      group('When upgradeTrainee is called', () {
        blocTest<TraineesCubit, TraineesState>(
          'Then updated trainees are saved to local storage',
          seed: () => TraineesState.initial().copyWith(
            trainees: [trainee],
          ),
          build: () => TraineesCubit(localStorageRepository: mockLocalStorage,
          )..setFilterTraineesCubit(mockFilterTraineesCubit),
          act: (cubit) => cubit.upgradeTrainee(trainee),
          verify: (_) {
            verify(() => mockLocalStorage.saveTrainees(any())).called(1);
          },
        );
      });
    });

    group('Given no local storage repository', () {
      group('When updateTraineeList is called', () {
        blocTest<TraineesCubit, TraineesState>(
          'Then no save is attempted',
          build: () => TraineesCubit(),
          act: (cubit) => cubit.updateTraineeList([trainee]),
          verify: (_) {
            verifyNever(() => mockLocalStorage.saveTrainees(any()));
          },
        );
      });
    });

    group('Given local storage has saved trainees', () {
      final cachedTrainee = Trainee(
        surname: 'Cached',
        forename: 'User',
        email: 'cached@example.de',
        dateOfBirth: '1990-01-01',
        trainingGroup: Group.group2,
      );

      setUp(() {
        when(() => mockLocalStorage.loadTrainees())
            .thenAnswer((_) async => [cachedTrainee]);
      });

      group('When updateTraineeList is called with new import data', () {
        blocTest<TraineesCubit, TraineesState>(
          'Then only the new imported trainees are used and cached state is overwritten',
          build: () => TraineesCubit(localStorageRepository: mockLocalStorage,
          )..setFilterTraineesCubit(mockFilterTraineesCubit),
          act: (cubit) => cubit.updateTraineeList([trainee]),
          expect: () => [
            predicate<TraineesState>((s) =>
                s.trainees.length == 1 &&
                s.trainees.first == trainee &&
                !s.trainees.contains(cachedTrainee)),
          ],
          verify: (_) {
            verify(() => mockLocalStorage.saveTrainees([trainee])).called(1);
          },
        );
      });
    });
  });
}
