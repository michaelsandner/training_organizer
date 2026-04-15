---
applyTo: "{test/**,integration_test/**}"
---

# Testing Conventions

## Directory Structure

The `test/` folder mirrors the `lib/` folder:

```
test/
  unit/
    domain/          # use case and domain logic tests
    features/        # cubit tests per feature
    model/           # model and entity tests
    import_export/   # import/export logic tests
    services/        # service tests
  widget/
    features/        # widget tests per feature
```

Integration tests live in `integration_test/`.

## Test Style — Gherkin (Given-When-Then)

Tests are organized with nested `group()` calls:

```dart
group('Given <precondition>', () {
  // setup for this precondition

  group('When <action>', () {
    test('Then <expected outcome>', () {
      // assertions
    });
  });
});
```

## Unit Tests for Cubits

- Use `blocTest` from `bloc_test` package for cubit tests
- Use `mocktail` for mocking dependencies

```dart
blocTest<MyCubit, MyState>(
  'Then state should update',
  build: () => MyCubit(),
  act: (cubit) => cubit.doSomething(),
  expect: () => [expectedState],
);
```

## Widget Tests

- Wrap the widget under test in `MaterialApp` and `Scaffold`
- Use `tester.ensureVisible()` before tapping widgets that might be off-screen (especially in scrollable views or dropdowns)
- DropdownButton mounts all items via IndexedStack — items may be at y=0 when the overlay opens

## Integration Tests

- Run on an Android emulator with a small screen (320×640 dp)
- Always call `tester.ensureVisible()` before tapping widgets that may be below the fold
- Use cubit state to verify data counts instead of `find.byType()` because `ListView.builder` virtualizes items

## Running Tests

```bash
flutter test              # all unit and widget tests
flutter test test/unit/   # unit tests only
flutter test test/widget/ # widget tests only
```

Integration tests run on an Android emulator (see CI workflow for the full setup):

```bash
flutter test integration_test/app_test.dart -d <device_id>
```
