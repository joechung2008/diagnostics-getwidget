# diagnostics-getwidget

Azure Portal Extensions Dashboard implemented in Flutter with GetWidget

## Features

- **Multi-environment support**: Public Cloud, Fairfax, and Mooncake
- **Extension diagnostics**: View extension information, configuration, and stage definitions
- **Build and server information**: Comprehensive system diagnostics
- **Responsive design**: Works on desktop and mobile devices
- **State management**: Riverpod (Notifier / NotifierProvider)

## Developer Workflow

### Prerequisites

- Flutter SDK (3.9.2 or later)
- Dart SDK (included with Flutter)

### Setup

1. **Clone the repository**

```bash
git clone https://github.com/joechung2008/diagnostics-getwidget.git
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
├── pages/                   # Page widgets
├── services/                # API services
└── widgets/                 # Reusable UI components
```

## Testing

This project includes unit and widget tests to ensure code quality and reliability.

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

The project uses **Mocktail** for creating mocks in tests.

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

The project uses **Riverpod** (Notifier / NotifierProvider) for reactive state management with dependency injection.

**Files:**

- `lib/pages/dashboard_page_riverpod.dart` - Main dashboard page
- `lib/controllers/dashboard_controller.dart` - Business logic controller
- `lib/models/dashboard_state.dart` - Shared state model

**Note:** This repository was migrated to Riverpod 3.x; tests commonly use `ProviderContainer` to override providers during testing.

## UI Components

This project uses **GetWidget** for consistent, Material Design 3 compliant UI components.

**Key Components Used:**

- `GFAppBar` - Application bar with actions
- `GFTabBar` / `TabBarView` - Tabbed navigation
- `GFIconButton` - Icon buttons

**Documentation:** [GetWidget Documentation](https://docs.getwidget.dev/)
