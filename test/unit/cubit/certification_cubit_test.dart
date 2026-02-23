import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/edit/ui/certification_cubit.dart';
import 'package:training_organizer/edit/ui/certification_state.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  group('Given no trainee (neuer Teilnehmer)', () {
    late CertificationCubit cubit;

    setUp(() {
      cubit = CertificationCubit(null);
    });

    tearDown(() => cubit.close());

    group('When the cubit is created', () {
      test('Then all checkboxes are false', () {
        expect(cubit.state, const CertificationState());
        expect(cubit.state.isPiratChecked, isFalse);
        expect(cubit.state.isBronzeChecked, isFalse);
        expect(cubit.state.isSilverChecked, isFalse);
        expect(cubit.state.isGoldChecked, isFalse);
        expect(cubit.state.isRSBronzeChecked, isFalse);
        expect(cubit.state.enableCurrentqualificationDate, isFalse);
      });
    });

    group('When togglePirat is called with true', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then isPiratChecked is true',
        build: () => CertificationCubit(null),
        act: (cubit) => cubit.togglePirat(true),
        expect: () => [const CertificationState(isPiratChecked: true)],
      );
    });

    group('When toggleBronze is called with true', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then isBronzeChecked is true',
        build: () => CertificationCubit(null),
        act: (cubit) => cubit.toggleBronze(true),
        expect: () => [const CertificationState(isBronzeChecked: true)],
      );
    });

    group('When toggleSilber is called with true', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then isSilverChecked is true',
        build: () => CertificationCubit(null),
        act: (cubit) => cubit.toggleSilber(true),
        expect: () => [const CertificationState(isSilverChecked: true)],
      );
    });

    group('When toggleGold is called with true', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then isGoldChecked is true',
        build: () => CertificationCubit(null),
        act: (cubit) => cubit.toggleGold(true),
        expect: () => [const CertificationState(isGoldChecked: true)],
      );
    });

    group('When toggleRsBronze is called with true', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then isRSBronzeChecked is true',
        build: () => CertificationCubit(null),
        act: (cubit) => cubit.toggleRsBronze(true),
        expect: () => [const CertificationState(isRSBronzeChecked: true)],
      );
    });

    group('When toggleCurrentQualificationDate is called with true', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then enableCurrentqualificationDate is true',
        build: () => CertificationCubit(null),
        act: (cubit) => cubit.toggleCurrentQualificationDate(true),
        expect: () =>
            [const CertificationState(enableCurrentqualificationDate: true)],
      );
    });

    group('When multiple toggles are called and then reset', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then state is reset to all false',
        build: () => CertificationCubit(null),
        act: (cubit) {
          cubit.togglePirat(true);
          cubit.toggleSilber(true);
          cubit.toggleCurrentQualificationDate(true);
          cubit.reset();
        },
        expect: () => [
          const CertificationState(isPiratChecked: true),
          const CertificationState(isPiratChecked: true, isSilverChecked: true),
          const CertificationState(
              isPiratChecked: true,
              isSilverChecked: true,
              enableCurrentqualificationDate: true),
          const CertificationState(),
        ],
      );
    });

    group('When createQualifications is called with Silber toggled', () {
      test('Then the result contains Silber', () {
        cubit.toggleSilber(true);
        final qualifications = cubit.createQualifications(null);

        expect(qualifications.any((q) => q.name == silber), isTrue);
        expect(qualifications.length, 1);
      });
    });
  });

  group('Given an existing trainee with Pirat and Bronze qualifications', () {
    late CertificationCubit cubit;
    late Trainee trainee;

    setUp(() {
      trainee = Trainee(
        surname: 'Mustermann',
        forename: 'Max',
        qualifications: [
          Pirat(DateTime(2022, 5, 10)),
          Bronze(DateTime(2023, 3, 1))
        ],
      );
      cubit = CertificationCubit(trainee);
    });

    tearDown(() => cubit.close());

    group('When the cubit is created', () {
      test('Then isPiratChecked and isBronzeChecked are true', () {
        expect(cubit.state.isPiratChecked, isTrue);
        expect(cubit.state.isBronzeChecked, isTrue);
        expect(cubit.state.isSilverChecked, isFalse);
        expect(cubit.state.isGoldChecked, isFalse);
        expect(cubit.state.isRSBronzeChecked, isFalse);
      });
    });

    group('When Silber is toggled on', () {
      test('Then createQualifications returns Pirat, Bronze and Silber', () {
        cubit.toggleSilber(true);
        final qualifications = cubit.createQualifications(trainee);

        expect(qualifications.any((q) => q.name == pirat), isTrue);
        expect(qualifications.any((q) => q.name == bronze), isTrue);
        expect(qualifications.any((q) => q.name == silber), isTrue);
        expect(qualifications.length, 3);
      });
    });

    group('When Bronze is toggled off', () {
      test('Then createQualifications does not contain Bronze', () {
        cubit.toggleBronze(false);
        final qualifications = cubit.createQualifications(trainee);

        expect(qualifications.any((q) => q.name == bronze), isFalse);
        expect(qualifications.any((q) => q.name == pirat), isTrue);
      });
    });

    group('When createQualifications is called without date toggle', () {
      test('Then existing dates are preserved', () {
        final qualifications = cubit.createQualifications(trainee);

        final piratQ = qualifications.firstWhere((q) => q.name == pirat);
        final bronzeQ = qualifications.firstWhere((q) => q.name == bronze);

        expect(piratQ.date, DateTime(2022, 5, 10));
        expect(bronzeQ.date, DateTime(2023, 3, 1));
      });
    });

    group('When createQualifications is called with date toggle enabled', () {
      test('Then dates are updated to today', () {
        final before = DateTime.now().subtract(const Duration(seconds: 1));

        cubit.toggleCurrentQualificationDate(true);
        final qualifications = cubit.createQualifications(trainee);

        for (final q
            in qualifications.where((q) => [pirat, bronze].contains(q.name))) {
          expect(q.date, isNotNull);
          expect(q.date!.isAfter(before), isTrue);
        }
      });
    });

    group('When Gold and RsBronze are added', () {
      test('Then createQualifications returns all five qualifications', () {
        cubit.toggleSilber(true);
        cubit.toggleGold(true);
        cubit.toggleRsBronze(true);
        final qualifications = cubit.createQualifications(trainee);

        expect(qualifications.any((q) => q.name == pirat), isTrue);
        expect(qualifications.any((q) => q.name == bronze), isTrue);
        expect(qualifications.any((q) => q.name == silber), isTrue);
        expect(qualifications.any((q) => q.name == gold), isTrue);
        expect(qualifications.any((q) => q.name == rettungsschwimmerBronze),
            isTrue);
        expect(qualifications.length, 5);
      });
    });
  });
}
