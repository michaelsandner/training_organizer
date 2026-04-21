# New Feature

Create a new feature following the project's Clean Architecture and conventions.

## Steps

1. **Domain layer** — define entities, use cases in `lib/domain/`, and repository interfaces in `lib/domain/repositories/`
2. **Data layer** — implement the repository in `lib/data/`
3. **Register dependencies** — add new services and use cases to `lib/di/service_locator.dart`
4. **Presentation layer** — create a feature folder in `lib/ui/features/<feature_name>/` with:
   - A Cubit and its State class (using `Equatable`)
   - Page and widget files (one widget class per file — no `_build*` methods)
5. **Tests** — add tests that mirror the `lib/` structure:
   - Unit tests for use cases in `test/unit/domain/`
   - Unit tests for the cubit in `test/unit/features/<feature_name>/`
   - Widget tests in `test/widget/features/<feature_name>/`
6. **Validate** — run `flutter analyze` and `flutter test` before finishing

## Conventions Checklist

- [ ] UI texts are in German
- [ ] Code comments, methods, and variables are in English
- [ ] Each class has its own file
- [ ] Cubit is used instead of Bloc
- [ ] All state fields are in the Equatable `props` list
- [ ] Shared widgets go into `lib/ui/shared/widgets/`
- [ ] Tests follow Given-When-Then (Gherkin) structure
