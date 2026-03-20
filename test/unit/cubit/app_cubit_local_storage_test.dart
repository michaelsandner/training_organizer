import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/email/domain/send_email_usecase.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/data/local_storage_repository.dart';
import 'package:training_organizer/overview/selection/selection_cubit.dart';
import 'package:training_organizer/overview/selection/selection_state.dart';

class MockSendEmailUseCase extends Mock implements SendEmailUseCase {}

class MockLocalStorageRepository extends Mock
    implements LocalStorageRepository {}

class MockSelectionCubit extends Mock implements SelectionCubit {}

void main() {
  late MockSendEmailUseCase mockSendEmailUseCase;
  late MockLocalStorageRepository mockLocalStorage;
  late MockSelectionCubit mockSelectionCubit;

  final trainee = Trainee(
    surname: 'Muster',
    forename: 'Max',
    email: 'max@example.de',
    dateOfBirth: '2000-01-01',
    trainingGroup: Group.group1,
  );

  setUp(() {
    mockSendEmailUseCase = MockSendEmailUseCase();
    mockLocalStorage = MockLocalStorageRepository();
    mockSelectionCubit = MockSelectionCubit();

    when(() => mockLocalStorage.saveTrainees(any()))
        .thenAnswer((_) async {});
    when(() => mockLocalStorage.loadTrainees())
        .thenAnswer((_) async => null);
    when(() => mockSelectionCubit.state).thenReturn(SelectionState.initial());
    when(() => mockSelectionCubit.setSelectedGroup(any(), any()))
        .thenAnswer((_) {});
    when(() => mockSelectionCubit.getFilteredGroup(any()))
        .thenReturn(FilterableGroup.all);
  });

  group('AppCubit with LocalStorage', () {
    group('Given local storage has saved trainees', () {
      setUp(() {
        when(() => mockLocalStorage.loadTrainees())
            .thenAnswer((_) async => [trainee]);
      });

      group('When init is called', () {
        blocTest<AppCubit, AppState>(
          'Then trainees are loaded from local storage',
          build: () => AppCubit(
            mockSendEmailUseCase,
            localStorageRepository: mockLocalStorage,
          )..setSelectionCubit(mockSelectionCubit),
          act: (cubit) => cubit.init(),
          expect: () => [
            AppState.initial().copyWith(
              trainees: [trainee],
            ),
          ],
        );
      });
    });

    group('Given local storage is empty', () {
      group('When init is called', () {
        blocTest<AppCubit, AppState>(
          'Then state remains unchanged',
          build: () => AppCubit(
            mockSendEmailUseCase,
            localStorageRepository: mockLocalStorage,
          ),
          act: (cubit) => cubit.init(),
          expect: () => [],
        );
      });
    });

    group('Given a cubit with local storage', () {
      group('When updateTraineeList is called', () {
        blocTest<AppCubit, AppState>(
          'Then trainees are saved to local storage',
          build: () => AppCubit(
            mockSendEmailUseCase,
            localStorageRepository: mockLocalStorage,
          )..setSelectionCubit(mockSelectionCubit),
          act: (cubit) => cubit.updateTraineeList([trainee]),
          verify: (_) {
            verify(() => mockLocalStorage.saveTrainees([trainee])).called(1);
          },
        );
      });

      group('When addTrainee is called', () {
        blocTest<AppCubit, AppState>(
          'Then trainees are saved to local storage',
          build: () => AppCubit(
            mockSendEmailUseCase,
            localStorageRepository: mockLocalStorage,
          )..setSelectionCubit(mockSelectionCubit),
          act: (cubit) => cubit.addTrainee(trainee),
          verify: (_) {
            verify(() => mockLocalStorage.saveTrainees([trainee])).called(1);
          },
        );
      });

      group('When removeTrainee is called', () {
        blocTest<AppCubit, AppState>(
          'Then trainees are saved to local storage',
          seed: () => AppState.initial().copyWith(
            trainees: [trainee],
          ),
          build: () => AppCubit(
            mockSendEmailUseCase,
            localStorageRepository: mockLocalStorage,
          )..setSelectionCubit(mockSelectionCubit),
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

        blocTest<AppCubit, AppState>(
          'Then updated trainees are saved to local storage',
          seed: () => AppState.initial().copyWith(
            trainees: [trainee],
          ),
          build: () => AppCubit(
            mockSendEmailUseCase,
            localStorageRepository: mockLocalStorage,
          )..setSelectionCubit(mockSelectionCubit),
          act: (cubit) => cubit.replaceTrainee(trainee, updatedTrainee),
          verify: (_) {
            verify(() =>
                    mockLocalStorage.saveTrainees([updatedTrainee]))
                .called(1);
          },
        );
      });

      group('When upgradeTrainee is called', () {
        blocTest<AppCubit, AppState>(
          'Then updated trainees are saved to local storage',
          seed: () => AppState.initial().copyWith(
            trainees: [trainee],
          ),
          build: () => AppCubit(
            mockSendEmailUseCase,
            localStorageRepository: mockLocalStorage,
          )..setSelectionCubit(mockSelectionCubit),
          act: (cubit) => cubit.upgradeTrainee(trainee),
          verify: (_) {
            verify(() => mockLocalStorage.saveTrainees(any())).called(1);
          },
        );
      });
    });

    group('Given no local storage repository', () {
      group('When updateTraineeList is called', () {
        blocTest<AppCubit, AppState>(
          'Then no save is attempted',
          build: () => AppCubit(mockSendEmailUseCase),
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
        blocTest<AppCubit, AppState>(
          'Then only the new imported trainees are used and cached state is overwritten',
          build: () => AppCubit(
            mockSendEmailUseCase,
            localStorageRepository: mockLocalStorage,
          )..setSelectionCubit(mockSelectionCubit),
          act: (cubit) => cubit.updateTraineeList([trainee]),
          expect: () => [
            predicate<AppState>((s) =>
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
