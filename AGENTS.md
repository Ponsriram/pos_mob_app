# AGENTS.md

A dedicated guide for AI coding agents working on this Flutter project.

---

## Project Overview

This is a Flutter application following **MVVM architecture** with:

- **State Management:** Riverpod with code generation (`riverpod_annotation`, `riverpod_generator`)
- **Error Handling:** `fpdart` for functional programming (`Either<Failure, T>`)
- **Async State:** `AsyncValue<T>` for loading/data/error states
- **Feature Modularity:** Each feature is self-contained (model/repository/viewmodel/view)

---

## Commands

### Setup & Dependencies

```bash
# Install dependencies
flutter pub get

# Run code generation (once)
dart run build_runner build --delete-conflicting-outputs

# Run code generation (watch mode during development)
dart run build_runner watch --delete-conflicting-outputs
```

### Build & Run

```bash
# Run in debug mode
flutter run

# Build APK (Android)
flutter build apk --release

# Build App Bundle (Android)
flutter build appbundle --release

# Build iOS
flutter build ios --release
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Linting & Analysis

```bash
# Analyze code for issues
flutter analyze

# Format code
dart format .

# Fix auto-fixable issues
dart fix --apply
```

---

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase configuration(if any)
├── init_dependencies.dart       # Dependency initialization
├── core/                        # Shared utilities, themes, constants
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   ├── widgets/                 # Reusable widgets
│   └── error/                   # Failure types
└── features/                    # Feature modules
    └── <feature_name>/
        ├── model/               # Data classes, DTOs, mappers
        ├── repository/          # Data access layer
        ├── viewmodel/           # Riverpod notifiers
        └── view/
            ├── pages/           # Full-screen widgets
            └── widgets/         # Feature-specific widgets
```

### Key Directories

- `lib/core/` – Shared code across all features (READ/WRITE)
- `lib/features/` – Feature modules (READ/WRITE)
- `assets/` – Images, fonts, Lottie animations (READ only)
- `android/`, `ios/` – Platform-specific code (ASK before modifying)
- `test/` – Unit and widget tests (READ/WRITE)

---

## Code Style Guidelines

### Naming Conventions

- **Files:** `snake_case.dart` (e.g., `attendance_viewmodel.dart`)
- **Classes:** `PascalCase` (e.g., `AttendanceViewModel`)
- **Functions/Methods:** `camelCase` (e.g., `fetchAttendance`)
- **Constants:** `camelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants
- **Private members:** Prefix with `_` (e.g., `_repository`)

### Import Order

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. Third-party packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

// 4. Project imports (relative or package)
import '../model/attendance_detail.dart';
import '../repository/attendance_remote_repository.dart';
```

---

## Architecture: MVVM with Riverpod

### Layer Responsibilities

| Layer | Responsibility | Returns |
|-------|---------------|---------|
| **Model** | Data classes, DTOs, JSON serialization | Plain Dart objects |
| **Repository** | API/DB access, error mapping | `Future<Either<Failure, T>>` |
| **ViewModel** | Business logic, state management | `AsyncValue<T>` |
| **View** | UI rendering, user interaction | Widgets |

### Repository Pattern

Repositories return `Either<Failure, T>` from `fpdart`. Map all exceptions to `Failure` inside the repository.

```dart
@riverpod
YourRepository yourRepository(Ref ref) {
  final client = ref.watch(httpClientProvider);
  return YourRepositoryImpl(client);
}

class YourRepositoryImpl implements YourRepository {
  final HttpClient _client;
  
  YourRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<Item>>> fetchItems() async {
    try {
      final response = await _client.get('/items');
      final items = (response.data as List).map((e) => Item.fromJson(e)).toList();
      return right(items);
    } on DioException catch (e) {
      return left(Failure(message: e.message ?? 'Network error'));
    } catch (e) {
      return left(Failure(message: 'Unexpected error: $e'));
    }
  }
}
```

### ViewModel Pattern

ViewModels use `@riverpod` annotation and extend `_$YourViewModel`. State is always `AsyncValue<T>`.

```dart
@riverpod
class YourViewModel extends _$YourViewModel {
  late final YourRepository _repo;

  @override
  FutureOr<YourState> build() async {
    _repo = ref.read(yourRepositoryProvider);
    
    final result = await _repo.fetchItems();
    return result.match(
      (failure) => throw failure,
      (data) => YourState(items: data),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final result = await _repo.fetchItems();
    state = result.match(
      (failure) => AsyncError(failure, StackTrace.current),
      (data) => AsyncData(YourState(items: data)),
    );
  }

  Future<void> submitItem(Item item) async {
    state = const AsyncLoading();
    final result = await _repo.createItem(item);
    state = await result.match(
      (failure) async => AsyncError(failure, StackTrace.current),
      (_) async {
        // Refresh data after successful mutation
        final refreshed = await _repo.fetchItems();
        return refreshed.match(
          (f) => AsyncError(f, StackTrace.current),
          (data) => AsyncData(YourState(items: data)),
        );
      },
    );
  }
}
```

### UI Pattern

Use `ref.watch` for state and `ref.listen` for side effects (snackbars, navigation).

```dart
class YourPage extends ConsumerWidget {
  const YourPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for errors to show snackbar (side effect only)
    ref.listen(yourViewModelProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = error is Failure ? error.message : 'Something went wrong';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
      );
    });

    final state = ref.watch(yourViewModelProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Page')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorWidget(
          message: error is Failure ? error.message : 'Error occurred',
          onRetry: () => ref.read(yourViewModelProvider.notifier).refresh(),
        ),
        data: (data) => YourContent(data: data, isLoading: isLoading),
      ),
    );
  }
}
```

---

## Testing Instructions

### Test File Naming

- Unit tests: `<file>_test.dart`
- Widget tests: `<widget>_test.dart`
- Place in `test/` mirroring `lib/` structure

### Running Tests

```bash
# Run all tests
flutter test

# Run with verbose output
flutter test --reporter expanded

# Run specific test
flutter test test/features/attendance/viewmodel/attendance_viewmodel_test.dart
```

### Test Structure Example

```dart
void main() {
  group('AttendanceViewModel', () {
    late ProviderContainer container;
    late MockAttendanceRepository mockRepo;

    setUp(() {
      mockRepo = MockAttendanceRepository();
      container = ProviderContainer(
        overrides: [
          attendanceRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('build() returns attendance data on success', () async {
      when(() => mockRepo.fetchAttendance())
          .thenAnswer((_) async => right(testAttendanceList));

      final viewModel = container.read(attendanceViewModelProvider.notifier);
      await viewModel.future;

      expect(container.read(attendanceViewModelProvider).value, isNotNull);
    });
  });
}
```

---

## Git Workflow

### Branch Naming

- `feature/<description>` – New features
- `fix/<description>` – Bug fixes
- `refactor/<description>` – Code refactoring
- `docs/<description>` – Documentation updates

### Commit Message Format

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

**Types:** `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`

**Examples:**
```
feat(attendance): add attendance percentage calculation
fix(auth): handle token refresh on 401 response
refactor(viewmodel): extract common loading logic to base class
docs(readme): update installation instructions
```

### Pull Request Guidelines

1. **Title:** `[<feature>] <Description>` (e.g., `[Attendance] Add detailed view`)
2. **Description:** Explain what changed and why
3. **Checklist before merging:**
   - [ ] `flutter analyze` passes with no issues
   - [ ] `flutter test` passes
   - [ ] Code generation is up to date (`dart run build_runner build`)
   - [ ] No hardcoded secrets or API keys

---

## Security Considerations

### Never Commit

- API keys or secrets
- `google-services.json` with production credentials
- `key.properties` or signing keys
- `.env` files with sensitive data
- User data or PII

### Sensitive Files (gitignore'd)

```
android/key.properties
android/app/google-services.json  # if production
ios/Runner/GoogleService-Info.plist
.env
*.jks
*.keystore
```

### Secret Management

- Use environment variables or secure storage for runtime secrets
- Firebase config should use environment-specific files
- Never log sensitive data

---

## Boundaries

### ✅ Always Do

- Run `flutter analyze` before committing
- Run `dart run build_runner build` after modifying annotated files
- Follow the MVVM pattern for new features
- Return `Either<Failure, T>` from repositories
- Use `AsyncValue<T>` in ViewModels
- Use `ref.listen` for side effects (snackbars, navigation)
- Write tests for new ViewModels

### ⚠️ Ask First

- Modifying `pubspec.yaml` dependencies
- Changing Firebase configuration
- Modifying `android/` or `ios/` platform code
- Changing database schema (ObjectBox entities)
- Adding new third-party packages

### 🚫 Never Do

- Commit secrets, API keys, or credentials
- Modify `*.g.dart` generated files manually
- Skip code generation after changing annotated code
- Put business logic directly in widgets
- Catch and swallow errors silently
- Use `BuildContext` in ViewModels
- Remove failing tests without fixing the underlying issue

---

## New Feature Checklist

When creating a new feature, follow this structure:

1. **Create feature folder:** `lib/features/<feature_name>/`

2. **Add Model:**
   ```
   model/
   ├── <feature>_model.dart
   └── <feature>_model.g.dart  # generated
   ```

3. **Add Repository:**
   ```
   repository/
   ├── <feature>_repository.dart
   └── <feature>_repository.g.dart  # generated
   ```

4. **Add ViewModel:**
   ```
   viewmodel/
   ├── <feature>_viewmodel.dart
   └── <feature>_viewmodel.g.dart  # generated
   ```

5. **Add Views:**
   ```
   view/
   ├── pages/
   │   └── <feature>_page.dart
   └── widgets/
       └── <feature>_widget.dart
   ```

6. **Run codegen:** `dart run build_runner build --delete-conflicting-outputs`

7. **Add tests:** `test/features/<feature_name>/`

---

## Common Patterns

### Loading State with Previous Data

Keep previous data visible while refreshing:

```dart
Future<void> refresh() async {
  state = state.copyWithPrevious(const AsyncLoading());
  // ... fetch and update
}
```

### Derived State

Create computed providers for filtered/transformed data:

```dart
@riverpod
List<Item> filteredItems(Ref ref) {
  final state = ref.watch(itemsViewModelProvider);
  final filter = ref.watch(filterProvider);
  
  return state.maybeWhen(
    data: (data) => data.items.where((i) => i.matches(filter)).toList(),
    orElse: () => [],
  );
}
```

## Troubleshooting

### Code Generation Issues

```bash
# Clean and regenerate
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Riverpod Provider Not Found

- Ensure `*.g.dart` file is imported
- Run code generation
- Check provider is properly annotated with `@riverpod`

### State Not Updating

- Verify using `ref.watch()` not `ref.read()` in `build()`
- Check that state is being set correctly in ViewModel
- Ensure widget is wrapped in `Consumer` or extends `ConsumerWidget`