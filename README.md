# Projects and Tasks

A Flutter app for managing projects and tasks: create projects with tasks, assign tasks to users, and track task status. Supports login/register, localization (English & Arabic), and a REST API backend.

---

## How to Run the Project

### Prerequisites

- **Flutter SDK** 3.9.0 or higher (`sdk: ^3.9.0` in `pubspec.yaml`)
- **Dart** 3.9.0+
- Android Studio / Xcode / VS Code (for running on device or simulator)

### Steps

1. **Clone the repository** (if applicable):
   ```bash
   git clone <repository-url>
   cd ProjectsAndTasks
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```
   Or specify a device:
   ```bash
   flutter run -d chrome    # Web
   flutter run -d android  # Android
   flutter run -d ios      # iOS
   ```

4. **Optional – run tests**:
   ```bash
   flutter test
   ```

### Configuration

- **API base URL**: Configured in `lib/features/*/data/constants/` (e.g. `TasksApiConstants.baseUrl`, `ProjectsApiConstants.baseUrl`). Default is `http://redfaire.ddns.net:8080/api`.
- **Localization**: Translation files are in `assets/en.json` and `assets/ar.json`. They are loaded automatically; ensure `assets/` is declared in `pubspec.yaml` (already done).
- **Auth**: The app uses token-based auth. If no token is stored, the app starts on the login screen; otherwise it opens the home shell (Projects / My Tasks / Settings).

---

## Architecture Explanation

The project follows a **feature-based, layered architecture** with clear separation between data, domain, and presentation.

### Folder Structure

```
lib/
├── core/                    # App-wide infrastructure
│   ├── constants/           # Cache keys, route names, strings, etc.
│   ├── network/             # Dio client, API error handling, ApiErrorModel
│   ├── styles/              # Colors, themes, sizes
│   └── utils/               # Route (AppRouter), localization, validators
│
├── features/                # Feature modules
│   ├── auth/                # Login, register
│   ├── home/                # Home shell, bottom nav
│   ├── projects/            # Projects list, create project
│   └── tasks/                # Project tasks, my tasks, assign, status update
│
└── shared/                  # Reusable across features
    ├── models/              # Shared data models
    ├── services/            # Locale storage, app localizations
    └── widgets/             # Buttons, form fields, loaders, bottom sheets
```

### Feature Layer (e.g. `features/projects`, `features/tasks`)

Each feature is split into three layers:

| Layer          | Path                    | Role |
|----------------|-------------------------|------|
| **Data**       | `data/`                 | API calls (datasources), DTOs (models), repository implementations. Uses `Either<ApiErrorModel, T>` (dartz) for success/error. |
| **Domain**     | `domain/repositories/`  | Abstract repository interfaces (e.g. `ProjectsRepository`, `TasksRepository`). No Flutter or external packages. |
| **Presentation** | `presentation/`       | UI (pages/screens) and state (cubits). Cubits use repositories and emit states (e.g. Loading, Loaded, Error). |

### Data Flow

1. **UI** (e.g. `ProjectsListScreen`) uses `BlocProvider` + `BlocBuilder` / `BlocConsumer` and calls `context.read<ProjectsCubit>().loadProjects()`.
2. **Cubit** calls the **repository** (e.g. `getProjects()`, `createProjectWithTasks()`).
3. **Repository** uses the **remote datasource** (Dio). The datasource returns `Either<ApiErrorModel, T>`; the repository maps `Left` to thrown `TasksException` / similar and returns the result for `Right`.
4. **Cubit** emits a new state (e.g. `ProjectsLoaded(projects)`) and the UI rebuilds.

### Core and Shared

- **Core**: Dio setup (`WebService`), API error handling, route generation (`AppRouter`), app themes, and global constants.
- **Shared**: Reusable widgets (e.g. `DefaultFormField`, `GeneralAppBar`, `DropDownBottomSheet`), locale/localization services, and shared models used by multiple features.

---

## State Management

The app uses **Bloc (Cubit)** as the main state management solution, with **Provider** used only for app-wide locale.

### Bloc / Cubit (flutter_bloc, bloc)

- **Packages**: `bloc: ^8.1.0`, `flutter_bloc: ^8.0.1`.
- **Usage**: One Cubit per feature (or per main screen) that holds business logic and emits immutable states.

| Feature   | Cubit              | Main states / actions |
|----------|--------------------|------------------------|
| Auth     | `AuthCubit`        | Login, register; `AuthLoading`, `AuthLoginSuccess`, `AuthError` |
| Projects | `ProjectsCubit`    | Load/create projects; pagination; `ProjectsLoading`, `ProjectsLoaded`, `ProjectsError` |
| Project tasks | `ProjectTasksCubit` | Load project tasks, add task, assign, update status; `ProjectTasksLoading`, `ProjectTasksLoaded`, `ProjectTasksError` |
| My tasks | `MyTasksCubit`     | Load my assigned tasks, pagination, update status; `MyTasksLoading`, `MyTasksLoaded`, `MyTasksError` |

- **Provisioning**: `BlocProvider` is created at the screen level (e.g. `ProjectTasksScreen`, `ProjectsListScreen`, `MyTasksScreen`) so each screen gets its own cubit instance.
- **Consumption**: `BlocBuilder<XxxCubit, XxxState>` for UI, `BlocConsumer` when both building UI and reacting to state (e.g. navigation, toasts).

### Provider

- **Package**: `provider: ^6.0.3`.
- **Usage**: Only for **locale / direction** in `main.dart`:
  - `ChangeNotifierProvider<LocalizationController>` wraps `MyApp`.
  - `LocalizationController` holds the current `Locale`; the app uses it for theme and `Directionality` (e.g. RTL for Arabic).

### Summary

- **Feature/screen state**: **Cubit** (loading, list, error, pagination, submit).
- **App-wide locale**: **Provider** (`LocalizationController`).
- **No GetX/Riverpod** used for core state; the codebase relies on Bloc + Provider as above.
