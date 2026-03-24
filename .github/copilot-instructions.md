# Copilot Instructions for sheepshead_counter

## Project
- Flutter project
- Platforms: Android, iOS, Web, Windows
- The Web version is a Progressive Web App (PWA) that can be installed on desktops and mobile devices

## Tooling
- linting with analyze options and lints package for code quality and common code style rules
- pipeline with code analysis, unit tests, and widget tests, and builds for each platform
- Dependency injection with get_it
- Use fvm for managing Flutter versions across the project

## Architecture
- Clean Architecture approach is used with layers: domain, data, presentation

### Domain layer
- Contains business logic and entities
- Use cases for all features (e.g. GetAllGamesUseCase, SaveGameUseCase, CreateGameUseCase)
- Repositories folder: Repositories as interfaces that define the contract for data access (e.g. GameRepository)

### Data layer
- Contains implementations of repositories and data sources for all features

### Presentation layer
- Presentation is organized by feature where each feature has its own folder
- each feature has its own folder containing the presentation layer (widgets, cubits, blocs, states etc.)
- flutter_bloc package for state management (prefere Cubit over Bloc for simplicity)
- Presentation is organized by feature where each feature has its own folder containing the presentation layer (widgets, cubits, etc.)
- Shared Widgets folder for widgets which are used across multiple features (e.g. custom buttons, dialogs, etc.)

#### UI and Widgets
- Use Widgets instead of build methods for better readability and testability
- Widgets are split in different files and folders based on their purpose and usage (e.g. home_page.dart, game_page.dart, etc.)
- Use Widgets instead of build methods for better readability and testability

## Testing
- Test folder structure mirrors the lib folder structure
- Unit tests for domain layer (business logic)
- Unit tests for data layer (repositories, data sources)
- Unit tests for Cubit classes in the presentation layer
- Tests written in Gherkin style (Given-When-Then)
- Each Given step is a group, each When step is a group

## Code Style
- German for UI texts
- Methods and variables in English
- Classes in PascalCase, files in snake_case
- Each class in a separate file
- Source code comments in English

## Agent guidelines
- run analyze before finish pull requests to ensure code quality and adherence to linting rules
- run tests before finish pull requests to ensure all tests pass and code is working as expected