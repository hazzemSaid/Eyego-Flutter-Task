# EyeGo Flutter Task

**Repository:** [https://github.com/hazzemSaid/Eyego-Flutter-Task](https://github.com/hazzemSaid/Eyego-Flutter-Task)

A Flutter authentication app with products browsing feature, built with Clean Architecture, Firebase Auth, Google Sign-In, DummyJSON API, and a minimalistic black/white/gray design.

## Features

- Email/password authentication (sign in + register)
- Google Sign-In
- Persistent login via SharedPreferences
- Products browsing with search and category filter
- Responsive grid layout (2/3/4 columns)
- Product detail page with full-screen image viewer (pinch to zoom)
- Infinite scroll pagination
- Pull to refresh
- Minimalistic black/white/gray theme

## Demo

https://github.com/user-attachments/assets/4a399209-18cd-4366-b578-df57d3d2fcd7

## Implementation Approach

The app follows Clean Architecture with three layers: domain, data, and presentation. The domain layer defines pure abstractions (entities, repository contracts, usecases) with no framework dependencies. The data layer implements these contracts using Firebase Auth, Dio, and SharedPreferences. The presentation layer uses Cubit for state management, keeping UI logic reactive and testable.

Authentication is handled through Firebase Auth with Email/Password and Google Sign-In. The remote datasource wraps Firebase SDKs, while a local datasource caches user data in SharedPreferences. On app launch, the cached user is restored instantly — no loading flicker. Firebase's auth state stream takes over in the background to sync the real session.

Products are fetched from DummyJSON API using Dio. The Cubit manages loading, error, and success states with `Either<Failure, T>` for type-safe error handling. Search is debounced at 500ms, categories are fetched dynamically, and infinite scroll triggers at 200px from the bottom.

Routing uses GoRouter with a refresh listener on Firebase's auth stream. The redirect logic automatically guards protected routes. Product detail receives the `Product` entity via `state.extra` — no serialization needed.

The theme is token-based: `AppColors`, `AppDimens`, and `AppTextStyles` define all visual constants. Widgets reference these tokens exclusively, making the black/white/gray palette consistent across every screen.

## Setup Instructions

### Prerequisites

- Flutter SDK `^3.12.1`
- Dart SDK `^3.12.1`
- A Firebase project with Authentication enabled (Email/Password + Google)
- Android Studio / Xcode for platform setup

### 1. Clone the repository

```bash
git clone https://github.com/hazzemSaid/Eyego-Flutter-Task.git
cd Eyego-Flutter-Task
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Firebase configuration

The project uses `flutterfire` with auto-generated `firebase_options.dart`. To connect your own Firebase project:

```bash
flutterfire configure
```

This will regenerate `lib/firebase_options.dart` with your project's credentials.

For Android, ensure `google-services.json` is in `android/app/`. For iOS, ensure `GoogleService-Info.plist` is in `ios/Runner/`.

### 4. Run the app

```bash
flutter run
```

### 5. Run tests

```bash
flutter test
```

## Architecture

```
lib/
├── core/
│   ├── constants/        # App-wide string and asset constants
│   ├── di/               # GetIt dependency injection wiring
│   ├── error/            # Domain Failure types + Firebase error mapper
│   ├── router/           # GoRouter setup with auth redirect
│   ├── theme/            # Colors, text styles, dimensions, ThemeData
│   ├── utils/            # Pure form validators
│   └── widgets/          # Reusable branded widgets (button, text field, logo, etc.)
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/   # Firebase Auth + Google Sign-In + SharedPreferences
    │   │   ├── models/        # UserModel extensions
    │   │   └── repositories/  # AuthRepository implementation
    │   ├── domain/
    │   │   ├── entities/      # AppUser entity
    │   │   ├── repositories/  # Abstract auth contract
    │   │   └── usecases/      # SignInWithEmail, SignUpWithEmail, SignInWithGoogle, SignOut
    │   └── presentation/
    │       ├── cubit/         # AuthCubit + AuthState (BLoC pattern)
    │       └── pages/         # Splash, Login, Register, Home screens
    └── products/
        ├── data/
        │   ├── datasources/   # Dio-based API calls to DummyJSON
        │   ├── models/        # ProductModel with JSON mapping
        │   └── repositories/  # ProductRepository implementation
        ├── domain/
        │   ├── entities/      # Product entity
        │   ├── repositories/  # Abstract product contract
        │   └── usecases/      # GetProducts, SearchProducts, GetCategories, GetProductsByCategory
        └── presentation/
            ├── cubit/         # ProductsCubit + ProductsState
            ├── pages/         # ProductsPage, ProductDetailPage
            └── widgets/       # ProductCard, CategoryChips, SearchBar, etc.
```

### Key Design Decisions

**Clean Architecture layers:**
- **Domain** layer defines pure contracts (repositories, usecases) with no Flutter/Firebase imports
- **Data** layer implements those contracts with Firebase SDKs, Dio, and SharedPreferences
- **Presentation** layer uses Cubit (via `flutter_bloc`) for state management

**Dependency injection** uses `get_it` with a single `setupLocator()` function that wires all dependencies. No `GetIt.I` calls scattered in widgets.

**Routing** uses `go_router` with a `GoRouterRefreshStream` that rebuilds the router on Firebase auth state changes. The redirect logic enforces auth guards automatically.

**Theme** is minimalistic with a token-based design system:
- `AppColors` defines the full palette (black, white, gray scale)
- `AppDimens` centralizes spacing, radius, and component sizing
- `AppTextStyles` provides reusable text style builders
- All widgets reference these tokens — no hardcoded values

**Auth persistence** uses `shared_preferences` to cache user data locally. On app restart, the cached user is shown immediately without waiting for Firebase to restore the session.

**Error handling** maps Firebase exceptions to domain `Failure` types via `FirebaseErrorMapper`, so the presentation layer never deals with raw exceptions.

**Products API** uses `dio` to fetch from DummyJSON (`https://dummyjson.com/products`) with support for search, category filter, and pagination.

### Dependencies

| Package | Purpose |
|---------|---------|
| `firebase_core` | Firebase initialization |
| `firebase_auth` | Email/password + Google authentication |
| `google_sign_in` | Google OAuth flow |
| `flutter_bloc` | Cubit state management |
| `get_it` | Service locator / dependency injection |
| `go_router` | Declarative routing with auth guards |
| `dartz` | Functional programming (Either type for error handling) |
| `equatable` | Value equality for states and failures |
| `dio` | HTTP client for API calls |
| `cached_network_image` | Image caching with placeholder/error widgets |
| `shared_preferences` | Local storage for auth persistence |

### Dev Dependencies

| Package | Purpose |
|---------|---------|
| `bloc_test` | Cubit testing utilities |
| `mocktail` | Mocking for unit/widget tests |
