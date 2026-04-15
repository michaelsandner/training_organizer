---
applyTo: "**/*.dart"
---

# Dart & Flutter Coding Conventions

## Widget Design

- Extract widgets into separate classes and files — do not use private `_build*` methods that return widgets
- Each widget class lives in its own file (one class per file)
- Widgets are split by purpose: pages, list items, buttons, dialogs, etc.

## State Management

- Use `Cubit` (from `flutter_bloc`) for state management — prefer `Cubit` over `Bloc`
- Each Cubit has a corresponding State class (e.g., `AttendanceCubit` / `AttendanceState`)
- States extend `Equatable` — include all fields in the `props` list so `BlocBuilder` detects changes

## Dependency Injection

- Register dependencies in `lib/di/service_locator.dart` using `get_it`
- Data-layer services are registered as lazy singletons
- Domain-layer use cases are registered as factories

## Naming

- Classes: `PascalCase`
- Files: `snake_case`
- Methods and variables: `camelCase` in English
- UI-facing strings: German

## Error Handling

- Display errors with `MaterialBanner` (red background, `Icons.error_outline`, dismiss action)

## Imports

- Use package imports (`package:training_organizer/...`) — avoid relative imports
