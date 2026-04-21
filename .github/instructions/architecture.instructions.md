---
applyTo: "lib/**"
---

# Clean Architecture

The project follows a Clean Architecture approach with three layers.

## Domain Layer (`lib/domain/`)

Contains business logic, entities, repository interfaces, and use cases.

- **Use cases** live in `lib/domain/usecases/` (e.g., `FilterTraineesUseCase`, `SendEmailUseCase`, `GetAttendanceStatisticsUseCase`)
- **Repository interfaces** live in `lib/domain/repositories/` (e.g., `FileRepository`, `EmailRepository`, `ExerciseRepository`)
- Feature-specific domain logic is in its own subfolder (e.g., `lib/domain/exercise_plan/`, `lib/domain/ical_parser/`)

## Data Layer (`lib/data/`)

Contains implementations of repository interfaces and data sources.

- Repository implementations (e.g., `LocalStorageService` implements `LocalStorageRepository`)
- File handlers for import/export (e.g., `FileExporter`, `PerformanceDataFileHandler`)
- Platform-specific code uses stub/conditional imports (e.g., `web_downloader_stub.dart` / `web_downloader_web.dart`)

## Presentation Layer (`lib/ui/`)

Organized into features and shared components.

### Features (`lib/ui/features/`)

Each feature has its own folder containing widgets, cubits, and states.

| Folder                   | Description                                   |
| ------------------------ | --------------------------------------------- |
| `attendance/`            | Attendance tracking with date picker and stats |
| `edit/`                  | Add/edit trainee data                          |
| `email/`                 | Email composition                              |
| `exercise_plan/`         | Exercise plan with carousel and list views     |
| `import_export/`         | File import/export cubit and state             |
| `overview/`              | Trainee list, filtering, and selection         |
| `performance_data/`      | Performance data and iCal import               |
| `rescue_qualification/`  | Rescue qualification management                |
| `statistic/`             | Statistics and charts                          |

### Shared Widgets (`lib/ui/shared/widgets/`)

Widgets used across multiple features live in `lib/ui/shared/widgets/`.

## Models (`lib/model/`)

Domain entities that are shared across layers:

- `Trainee` — core entity with attendance data, qualifications, and group membership
- `TrainingGroup` / `Group` — training group enum and related logic
- `Qualifications` — qualification types with validity logic (in `lib/model/qualifications/`)
