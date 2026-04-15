# Copilot Instructions for training_organizer

## Project Overview

A Flutter application for organizing swim training sessions and managing trainees.
Platforms: Android, iOS, Web (PWA), Windows.

## Tooling

- **Flutter version**: managed via fvm (see `.fvm/fvm_config.json`)
- **Linting**: `flutter analyze` using `analysis_options.yaml` with `flutter_lints`
- **CI pipeline**: code analysis, unit tests, widget tests, integration tests, and builds for Web, Windows, and Android (see `.github/workflows/main.yml`)
- **Dependency injection**: `get_it` package (see `lib/di/service_locator.dart`)
- **State management**: `flutter_bloc` package — prefer `Cubit` over `Bloc` for simplicity

## Code Style

- German for UI texts
- Methods, variables, and source code comments in English
- Classes in PascalCase, files in snake_case
- Each class in a separate file

## Agent Guidelines

- Run `flutter analyze` before finishing pull requests
- Run `flutter test` before finishing pull requests
- Scoped instructions for Dart files, architecture, and testing are in `.github/instructions/`
- Reusable prompt templates for common tasks are in `.github/prompts/`