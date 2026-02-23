# Copilot Instructions

## Project
- Target platforms: Android, iOS, Web, Windows

## Architecture
- Clean Architecture with layers: presentation, domain, data
- Each feature has its own folder with the same structure (presentation, domain, data)
- State management: flutter_bloc (Cubit)

## Tests
- Unit tests for domain layer (business logic)
- Unit tests for Cubit classes in the presentation layer
- Unit tests are written in Gherkin style (Given-When-Then)
- Each Given step is a group
- Each When step is a group


## Conventions
- German for UI texts and comments
- Methods and variables in English
- Classes in PascalCase, files in snake_case

## Special rules


## Agent guidelines
<!-- Add further notes here, e.g.: -->
<!-- - Do not add external packages without asking -->
<!-- - Write tests for new use cases -->
<!-- - ... -->
