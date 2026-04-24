import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/ui/features/edit/certification_cubit.dart';
import 'package:training_organizer/ui/features/edit/certification_state.dart';
import 'package:training_organizer/model/qualifications.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

import 'package:training_organizer/model/trainee.dart';

void main() {
  final qualificationFactory = QualificationFactory();

  group('Given no trainee (neuer Teilnehmer)', () {
    late CertificationCubit cubit;

    setUp(() {
      cubit = CertificationCubit(null, qualificationFactory);
    });

    tearDown(() => cubit.close());

    group('When the cubit is created', () {
      test('Then qualifications list is empty', () {
        expect(cubit.state, const CertificationState());
        expect(cubit.state.qualifications, isEmpty);
      });
    });

    group('When addQualification is called with Pirat', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then state contains Pirat qualification',
        build: () => CertificationCubit(null, qualificationFactory),
        act: (cubit) => cubit.addQualification(pirat, null),
        verify: (cubit) {
          expect(cubit.state.qualifications.length, 1);
          expect(cubit.state.qualifications.first.name, pirat);
        },
      );
    });

    group('When addQualification is called with Bronze and a date', () {
      final date = DateTime(2023, 6, 15);

      blocTest<CertificationCubit, CertificationState>(
        'Then state contains Bronze qualification with date',
        build: () => CertificationCubit(null, qualificationFactory),
        act: (cubit) => cubit.addQualification(bronze, date),
        verify: (cubit) {
          expect(cubit.state.qualifications.length, 1);
          expect(cubit.state.qualifications.first.name, bronze);
          expect(cubit.state.qualifications.first.date, date);
        },
      );
    });

    group('When multiple qualifications are added and then reset', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then state is reset to empty',
        build: () => CertificationCubit(null, qualificationFactory),
        act: (cubit) {
          cubit.addQualification(pirat, null);
          cubit.addQualification(silber, DateTime(2023, 1, 1));
          cubit.reset();
        },
        verify: (cubit) {
          expect(cubit.state.qualifications, isEmpty);
        },
      );
    });

    group('When addQualification is called with Silber', () {
      test('Then getQualifications returns Qualifications with Silber', () {
        cubit.addQualification(silber, null);
        final qualifications = cubit.getQualifications();

        expect(
            qualifications.qualifications.any((q) => q.name == silber), isTrue);
        expect(qualifications.qualifications.length, 1);
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
        qualifications: Qualifications(qualifications: [
          Pirat(DateTime(2022, 5, 10)),
          Bronze(DateTime(2023, 3, 1))
        ]),
      );
      cubit = CertificationCubit(trainee, qualificationFactory);
    });

    tearDown(() => cubit.close());

    group('When the cubit is created', () {
      test('Then qualifications contain Pirat and Bronze', () {
        expect(cubit.state.qualifications.length, 2);
        expect(
            cubit.state.qualifications.any((q) => q.name == pirat), isTrue);
        expect(
            cubit.state.qualifications.any((q) => q.name == bronze), isTrue);
      });
    });

    group('When Silber is added', () {
      test('Then getQualifications returns Pirat, Bronze and Silber', () {
        cubit.addQualification(silber, null);
        final qualifications = cubit.getQualifications();

        expect(
            qualifications.qualifications.any((q) => q.name == pirat), isTrue);
        expect(
            qualifications.qualifications.any((q) => q.name == bronze), isTrue);
        expect(
            qualifications.qualifications.any((q) => q.name == silber), isTrue);
        expect(qualifications.qualifications.length, 3);
      });
    });

    group('When Bronze is removed by index', () {
      test('Then getQualifications does not contain Bronze', () {
        final bronzeIndex = cubit.state.qualifications
            .indexWhere((q) => q.name == bronze);
        cubit.removeQualification(bronzeIndex);
        final qualifications = cubit.getQualifications();

        expect(qualifications.qualifications.any((q) => q.name == bronze),
            isFalse);
        expect(
            qualifications.qualifications.any((q) => q.name == pirat), isTrue);
      });
    });

    group('When getQualifications is called', () {
      test('Then existing dates are preserved', () {
        final qualifications = cubit.getQualifications();

        final piratQ =
            qualifications.qualifications.firstWhere((q) => q.name == pirat);
        final bronzeQ =
            qualifications.qualifications.firstWhere((q) => q.name == bronze);

        expect(piratQ.date, DateTime(2022, 5, 10));
        expect(bronzeQ.date, DateTime(2023, 3, 1));
      });
    });

    group('When Gold and Silber are added', () {
      test('Then getQualifications returns all four qualifications', () {
        cubit.addQualification(silber, null);
        cubit.addQualification(gold, null);
        final qualifications = cubit.getQualifications();

        expect(
            qualifications.qualifications.any((q) => q.name == pirat), isTrue);
        expect(
            qualifications.qualifications.any((q) => q.name == bronze), isTrue);
        expect(
            qualifications.qualifications.any((q) => q.name == silber), isTrue);
        expect(
            qualifications.qualifications.any((q) => q.name == gold), isTrue);
        expect(qualifications.qualifications.length, 4);
      });
    });
  });

  group('Given an existing trainee with only Gold qualification', () {
    late CertificationCubit cubit;
    late Trainee trainee;

    setUp(() {
      trainee = Trainee(
        surname: 'Mustermann',
        forename: 'Max',
        qualifications:
            Qualifications(qualifications: [Gold(DateTime(2023, 7, 20))]),
      );
      cubit = CertificationCubit(trainee, qualificationFactory);
    });

    tearDown(() => cubit.close());

    group('When the cubit is created', () {
      test('Then qualifications contain only Gold', () {
        expect(cubit.state.qualifications.length, 1);
        expect(
            cubit.state.qualifications.any((q) => q.name == gold), isTrue);
      });
    });

    group('When Silber is added', () {
      test('Then getQualifications returns both Silber and Gold', () {
        cubit.addQualification(silber, null);
        final qualifications = cubit.getQualifications();

        expect(
            qualifications.qualifications.any((q) => q.name == silber), isTrue);
        expect(
            qualifications.qualifications.any((q) => q.name == gold), isTrue);
        expect(qualifications.qualifications.length, 2);
      });
    });
  });

  group('Given no trainee (neuer Teilnehmer)', () {
    late CertificationCubit cubit;

    setUp(() {
      cubit = CertificationCubit(null, qualificationFactory);
    });

    tearDown(() => cubit.close());

    group('When addQualification is called with isAchievedIntern false', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then state contains Bronze qualification with isAchievedIntern false',
        build: () => CertificationCubit(null, qualificationFactory),
        act: (cubit) =>
            cubit.addQualification(bronze, null, isAchievedIntern: false),
        verify: (cubit) {
          expect(cubit.state.qualifications.length, 1);
          expect(cubit.state.qualifications.first.name, bronze);
          expect(cubit.state.qualifications.first.isAchievedIntern, isFalse);
        },
      );
    });

    group('When addQualification is called without isAchievedIntern', () {
      blocTest<CertificationCubit, CertificationState>(
        'Then state contains Bronze qualification with isAchievedIntern true by default',
        build: () => CertificationCubit(null, qualificationFactory),
        act: (cubit) => cubit.addQualification(bronze, null),
        verify: (cubit) {
          expect(cubit.state.qualifications.length, 1);
          expect(cubit.state.qualifications.first.isAchievedIntern, isTrue);
        },
      );
    });
  });
}
