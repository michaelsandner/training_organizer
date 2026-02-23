import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';
import 'package:training_organizer/model/qualifications/rs_silber.dart';
import 'package:training_organizer/model/qualifications/silber.dart';
import 'package:training_organizer/services/qualification_service.dart';

void main() {
  group('Given an empty qualification list', () {
    group('When addQualifications is called with all flags false', () {
      test('Then an empty list is returned', () {
        final result = addQualifications(
          currentQualifications: [],
          shouldSetCurrentDate: false,
          shouldAddPirat: false,
          shouldAddBronze: false,
          shouldAddSilber: false,
          shouldAddGold: false,
          shouldAddRsBronze: false,
        );

        expect(result, isEmpty);
      });
    });

    group('When addQualifications is called with all flags true', () {
      test('Then all five qualifications are added', () {
        final result = addQualifications(
          currentQualifications: [],
          shouldSetCurrentDate: false,
          shouldAddPirat: true,
          shouldAddBronze: true,
          shouldAddSilber: true,
          shouldAddGold: true,
          shouldAddRsBronze: true,
        );

        expect(result.length, 5);
        expect(result.any((q) => q.name == pirat), isTrue);
        expect(result.any((q) => q.name == bronze), isTrue);
        expect(result.any((q) => q.name == silber), isTrue);
        expect(result.any((q) => q.name == gold), isTrue);
        expect(result.any((q) => q.name == rettungsschwimmerBronze), isTrue);
      });
    });

    group('When addQualifications is called with shouldSetCurrentDate true',
        () {
      test('Then added qualifications have a date', () {
        final before = DateTime.now().subtract(const Duration(seconds: 1));

        final result = addQualifications(
          currentQualifications: [],
          shouldSetCurrentDate: true,
          shouldAddPirat: true,
          shouldAddBronze: false,
          shouldAddSilber: false,
          shouldAddGold: false,
          shouldAddRsBronze: false,
        );

        final piratQ = result.firstWhere((q) => q.name == pirat);
        expect(piratQ.date, isNotNull);
        expect(piratQ.date!.isAfter(before), isTrue);
      });
    });
  });

  group('Given an existing qualification list with Pirat', () {
    final existingDate = DateTime(2022, 6, 1);
    final existing = [Pirat(existingDate)];

    group(
        'When addQualifications is called with shouldAddPirat true and shouldSetCurrentDate false',
        () {
      test('Then the existing date is preserved', () {
        final result = addQualifications(
          currentQualifications: existing,
          shouldSetCurrentDate: false,
          shouldAddPirat: true,
          shouldAddBronze: false,
          shouldAddSilber: false,
          shouldAddGold: false,
          shouldAddRsBronze: false,
        );

        final piratQ = result.firstWhere((q) => q.name == pirat);
        expect(piratQ.date, existingDate);
      });
    });

    group(
        'When addQualifications is called with shouldAddPirat true and shouldSetCurrentDate true',
        () {
      test('Then the date is updated to today', () {
        final before = DateTime.now().subtract(const Duration(seconds: 1));

        final result = addQualifications(
          currentQualifications: existing,
          shouldSetCurrentDate: true,
          shouldAddPirat: true,
          shouldAddBronze: false,
          shouldAddSilber: false,
          shouldAddGold: false,
          shouldAddRsBronze: false,
        );

        final piratQ = result.firstWhere((q) => q.name == pirat);
        expect(piratQ.date, isNotNull);
        expect(piratQ.date!.isAfter(before), isTrue);
      });
    });

    group('When addQualifications is called with shouldAddPirat false', () {
      test('Then Pirat is removed from the list', () {
        final result = addQualifications(
          currentQualifications: existing,
          shouldSetCurrentDate: false,
          shouldAddPirat: false,
          shouldAddBronze: false,
          shouldAddSilber: false,
          shouldAddGold: false,
          shouldAddRsBronze: false,
        );

        expect(result.any((q) => q.name == pirat), isFalse);
      });
    });
  });

  group('Given a list with a non-checkbox qualification (RsSilber)', () {
    final rsSilber = RsSilber(DateTime(2024, 1, 1));
    final existing = [rsSilber];

    group('When addQualifications is called with Bronze added', () {
      test('Then RsSilber is preserved alongside Bronze', () {
        final result = addQualifications(
          currentQualifications: existing,
          shouldSetCurrentDate: false,
          shouldAddPirat: false,
          shouldAddBronze: true,
          shouldAddSilber: false,
          shouldAddGold: false,
          shouldAddRsBronze: false,
        );

        expect(result.any((q) => q.name == rettungsschwimmerSilber), isTrue);
        expect(result.any((q) => q.name == bronze), isTrue);
        expect(result.length, 2);
      });
    });

    group('When addQualifications is called with all flags false', () {
      test('Then RsSilber is preserved', () {
        final result = addQualifications(
          currentQualifications: existing,
          shouldSetCurrentDate: false,
          shouldAddPirat: false,
          shouldAddBronze: false,
          shouldAddSilber: false,
          shouldAddGold: false,
          shouldAddRsBronze: false,
        );

        expect(result.length, 1);
        expect(result.first.name, rettungsschwimmerSilber);
      });
    });
  });

  group('Given a list with Silber and Bronze', () {
    final existing = [
      Silber(DateTime(2021, 3, 15)),
      Bronze(DateTime(2020, 1, 1))
    ];

    group('When addQualifications is called with only Silber checked', () {
      test('Then Bronze is removed and Silber is preserved', () {
        final result = addQualifications(
          currentQualifications: existing,
          shouldSetCurrentDate: false,
          shouldAddPirat: false,
          shouldAddBronze: false,
          shouldAddSilber: true,
          shouldAddGold: false,
          shouldAddRsBronze: false,
        );

        expect(result.any((q) => q.name == silber), isTrue);
        expect(result.any((q) => q.name == bronze), isFalse);
        expect(result.length, 1);
      });
    });

    group('When addQualifications is called with Gold added', () {
      test('Then Silber, Bronze, and Gold are all present', () {
        final result = addQualifications(
          currentQualifications: existing,
          shouldSetCurrentDate: false,
          shouldAddPirat: false,
          shouldAddBronze: true,
          shouldAddSilber: true,
          shouldAddGold: true,
          shouldAddRsBronze: false,
        );

        expect(result.any((q) => q.name == silber), isTrue);
        expect(result.any((q) => q.name == bronze), isTrue);
        expect(result.any((q) => q.name == gold), isTrue);
        expect(result.length, 3);
      });
    });
  });
}
