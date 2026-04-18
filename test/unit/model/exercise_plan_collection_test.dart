import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_collection.dart';

void main() {
  group('ExercisePlanCollection', () {
    group('Given a collection is created', () {
      const collection = ExercisePlanCollection(
        name: 'Test Plan',
        planString: '1-2-3',
      );

      group('When toJson is called', () {
        test('Then it returns a valid JSON map', () {
          final json = collection.toJson();
          expect(json['name'], 'Test Plan');
          expect(json['planString'], '1-2-3');
        });
      });

      group('When fromJson is called', () {
        test('Then it creates a valid collection', () {
          final json = {'name': 'Test Plan', 'planString': '1-2-3'};
          final result = ExercisePlanCollection.fromJson(json);
          expect(result.name, 'Test Plan');
          expect(result.planString, '1-2-3');
        });
      });

      group('When JSON round-trip is performed', () {
        test('Then the collection survives serialization', () {
          final jsonString = jsonEncode(collection.toJson());
          final decoded =
              jsonDecode(jsonString) as Map<String, dynamic>;
          final result = ExercisePlanCollection.fromJson(decoded);
          expect(result, collection);
        });
      });
    });

    group('Given a list of collections', () {
      const collections = [
        ExercisePlanCollection(name: 'Plan A', planString: '1-2-3'),
        ExercisePlanCollection(name: 'Plan B', planString: '3-2-1'),
      ];

      group('When serialized as a collection JSON', () {
        test('Then it round-trips correctly', () {
          final map = {
            'collections': collections.map((c) => c.toJson()).toList(),
          };
          final jsonString = jsonEncode(map);
          final decoded =
              jsonDecode(jsonString) as Map<String, dynamic>;
          final list = decoded['collections'] as List<dynamic>;
          final result = list
              .map((e) => ExercisePlanCollection.fromJson(
                  e as Map<String, dynamic>))
              .toList();
          expect(result.length, 2);
          expect(result[0].name, 'Plan A');
          expect(result[1].name, 'Plan B');
        });
      });
    });

    group('Given two collections with same data', () {
      group('When compared for equality', () {
        test('Then they are equal', () {
          const a = ExercisePlanCollection(
            name: 'Plan',
            planString: '1-2',
          );
          const b = ExercisePlanCollection(
            name: 'Plan',
            planString: '1-2',
          );
          expect(a, b);
        });
      });
    });
  });
}
