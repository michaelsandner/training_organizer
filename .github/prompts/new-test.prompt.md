# New Test

Write tests for existing or new code following the project's testing conventions.

## Test Structure

Place the test file so it mirrors the `lib/` path:

- `lib/ui/features/overview/trainees_cubit.dart` → `test/unit/features/overview/trainees_cubit_test.dart`
- `lib/domain/usecases/filter_trainees_usecase.dart` → `test/unit/domain/filter_trainees_usecase_test.dart`

## Template

```dart
import 'package:flutter_test/flutter_test.dart';
// Add imports for the class under test and dependencies

void main() {
  // Setup shared across all groups
  late MyClass sut;

  setUp(() {
    sut = MyClass();
  });

  group('Given <precondition>', () {
    group('When <action>', () {
      test('Then <expected outcome>', () {
        // Arrange (if additional setup needed)
        // Act
        // Assert
      });
    });
  });
}
```

## Cubit Tests

Use `blocTest` from `bloc_test` and `mocktail` for mocking:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDependency extends Mock implements Dependency {}

blocTest<MyCubit, MyState>(
  'Then state should reflect the change',
  build: () => MyCubit(mockDep),
  act: (cubit) => cubit.performAction(),
  expect: () => [expectedState],
);
```

## Widget Tests

Wrap the widget in `MaterialApp` + `Scaffold`:

```dart
Widget buildWidget() {
  return MaterialApp(
    home: Scaffold(
      body: MyWidget(),
    ),
  );
}

testWidgets('Then widget displays expected text', (tester) async {
  await tester.pumpWidget(buildWidget());
  expect(find.text('Expected'), findsOneWidget);
});
```

## Checklist

- [ ] Test file mirrors the `lib/` folder structure
- [ ] Tests use Given-When-Then (Gherkin) style groups
- [ ] Cubit tests use `blocTest` and `mocktail`
- [ ] Widget tests wrap in `MaterialApp` and `Scaffold`
- [ ] All tests pass with `flutter test`
