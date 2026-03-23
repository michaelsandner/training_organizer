import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/ical_parser/rules/ical_parser_rule.dart';
import 'package:training_organizer/domain/ical_parser/rules/mixins/per_event_position_mixin.dart';

class _TestPerEventPosition with PerEventPositionMixin {
  @override
  String get targetCategoryName => 'TestCategory';
}

void main() {
  late _TestPerEventPosition sut;

  setUp(() {
    sut = _TestPerEventPosition();
  });

  group('PerEventPositionMixin', () {
    group('Given a fresh instance', () {
      test('Then perEventTotal is 0', () {
        expect(sut.perEventTotal, 0);
      });

      test('Then applyEntries is empty', () {
        expect(sut.applyEntries, isEmpty);
      });

      test('Then displayRows shows 0', () {
        expect(sut.displayRows, hasLength(1));
        expect(sut.displayRows.first.label, 'TestCategory');
        expect(sut.displayRows.first.value, 0);
      });
    });

    group('Given two entries are added', () {
      group('When addPerEventEntry is called for each', () {
        test('Then perEventTotal is the sum of values', () {
          sut.addPerEventEntry(const IcalRuleApplyEntry(
            targetCategoryName: 'TestCategory',
            value: 3,
            beschreibung: 'Event A',
          ));
          sut.addPerEventEntry(const IcalRuleApplyEntry(
            targetCategoryName: 'TestCategory',
            value: 2,
            beschreibung: 'Event B',
          ));

          expect(sut.perEventTotal, 5);
        });

        test('Then applyEntries contains both entries', () {
          sut.addPerEventEntry(const IcalRuleApplyEntry(
            targetCategoryName: 'TestCategory',
            value: 3,
            beschreibung: 'Event A',
          ));
          sut.addPerEventEntry(const IcalRuleApplyEntry(
            targetCategoryName: 'TestCategory',
            value: 2,
            beschreibung: 'Event B',
          ));

          expect(sut.applyEntries, hasLength(2));
          expect(sut.applyEntries[0].beschreibung, 'Event A');
          expect(sut.applyEntries[1].beschreibung, 'Event B');
        });

        test('Then displayRows shows the total', () {
          sut.addPerEventEntry(const IcalRuleApplyEntry(
            targetCategoryName: 'TestCategory',
            value: 3,
            beschreibung: 'Event A',
          ));
          sut.addPerEventEntry(const IcalRuleApplyEntry(
            targetCategoryName: 'TestCategory',
            value: 2,
            beschreibung: 'Event B',
          ));

          expect(sut.displayRows.first.value, 5);
        });
      });
    });

    group('Given entries were added', () {
      group('When resetPerEventEntries is called', () {
        test('Then perEventTotal is 0 and applyEntries is empty', () {
          sut.addPerEventEntry(const IcalRuleApplyEntry(
            targetCategoryName: 'TestCategory',
            value: 3,
            beschreibung: 'Event A',
          ));

          sut.resetPerEventEntries();

          expect(sut.perEventTotal, 0);
          expect(sut.applyEntries, isEmpty);
        });
      });
    });
  });
}
