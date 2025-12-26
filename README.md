# pos_app

A Flutter POS (Point of Sale) application following MVVM architecture with Riverpod state management.

## 📚 Documentation

- **[AGENTS.md](AGENTS.md)** - Comprehensive guide for AI coding agents and developers
- **[NAVIGATION.md](NAVIGATION.md)** - Navigation system guide and best practices

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)

### Setup

```bash
# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## 🏗️ Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture with:

- **State Management:** Riverpod with code generation
- **Error Handling:** `fpdart` for functional programming (`Either<Failure, T>`)
- **Async State:** `AsyncValue<T>` for loading/data/error states
- **Navigation:** Centralized route management system

## 📁 Project Structure

```
lib/
├── core/               # Shared utilities, themes, widgets
│   ├── routes/        # Navigation & routing
│   ├── theme/         # App theming
│   └── widgets/       # Reusable widgets
└── features/          # Feature modules (MVVM)
    └── <feature>/
        ├── model/     # Data classes
        ├── repository/# Data layer
        ├── viewmodel/ # Business logic
        └── view/      # UI components
```

## 🚀 Quick Commands

```bash
# Code generation (watch mode)
dart run build_runner watch --delete-conflicting-outputs

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .
```

## 📖 Learn More

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [FpDart Documentation](https://pub.dev/packages/fpdart)
