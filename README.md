# diagnostics-getwidget

Azure Portal Extensions Dashboard implemented in Flutter with GetWidget

## Overview

This Flutter application provides a diagnostics dashboard for Azure Portal extensions, featuring modern state management patterns and a clean, responsive UI built with GetWidget components.

## Features

- **Multi-environment support**: Public Cloud, Fairfax, and Mooncake
- **Extension diagnostics**: View extension information, configuration, and stage definitions
- **Build and server information**: Comprehensive system diagnostics
- **Responsive design**: Works on desktop and mobile devices
- **Modern architecture**: Multiple state management implementations available
 - **Modern architecture**: Riverpod for state management

## Developer Workflow

### Prerequisites

- Flutter SDK (3.9.2 or later)
- Dart SDK (included with Flutter)

### Setup

1. **Clone the repository**

```bash
git clone <repository-url>
cd diagnostics-getwidget
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the application**

```bash
flutter run
```

For web development:

```bash
flutter run -d chrome
```

### Development Commands

- **Analyze code**: `flutter analyze`
- **Run tests**: `flutter test`
- **Format code**: `dart format .`
- **Build for production**: `flutter build web`

### Project Structure

```
lib/
├── controllers/             # Riverpod controllers
├── models/                  # Data models and state classes
├── pages/                   # Page widgets (Riverpod versions)
├── services/                # API services
└── widgets/                 # Reusable UI components
```

## Testing

This project includes comprehensive unit and widget tests to ensure code quality and reliability.

### Test Structure

```
test/
├── controllers/             # Riverpod controller tests
├── models/                  # Data model tests
├── pages/                   # Page widget tests
├── services/                # Service layer tests
└── widgets/                 # UI component tests
```

### Mocking with Mocktail

The project uses **Mocktail** for creating mocks in tests, providing a modern and type-safe mocking solution.

**Key Features:**

- Type-safe mock generation
- Easy setup and verification
- Support for async operations
- Integration with Flutter's testing framework

**Example Usage:**

```dart
// Mock service
class MockDiagnosticsService extends Mock implements DiagnosticsService {}

// Setup in tests
setUpAll(() {
  registerFallbackValue(Environment.public);
});

setUp(() {
  mockService = MockDiagnosticsService();
  when(() => mockService.fetchDiagnostics(any()))
      .thenAnswer((_) async => mockDiagnostics);
});
```

**Documentation:** [Mocktail Documentation](https://pub.dev/packages/mocktail)

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/dashboard_state_test.dart
```

## Architecture

This project demonstrates two modern Flutter state management approaches:

### Riverpod Implementation

The primary implementation uses **Riverpod** for reactive state management with dependency injection.

**Key Features:**

- Declarative state management with providers
- Automatic dependency injection
- Excellent testability and reusability
- Less boilerplate than traditional approaches

**Files:**

- `lib/pages/dashboard_page_riverpod.dart` - Main dashboard page
- `lib/controllers/dashboard_controller.dart` - Business logic controller
- `lib/models/dashboard_state.dart` - Shared state model

**Documentation:** [Riverpod Documentation](https://riverpod.dev/)

This project uses Riverpod exclusively for state management. Use `lib/pages/dashboard_page_riverpod.dart` and the controllers under `lib/controllers/` for business logic and state.

## UI Components

This project uses **GetWidget** for consistent, Material Design 3 compliant UI components.

**Key Components Used:**

- `GFAppBar` - Application bar with actions
- `GFTabBar` / `TabBarView` - Tabbed navigation
- `GFIconButton` - Icon buttons

**Documentation:** [GetWidget Documentation](https://docs.getwidget.dev/)
