# Flutter Practice 1

## Firebase authentication setup

The app uses Firebase Authentication with email/password sign-in, registration,
profile updates, and a persisted session snapshot in `shared_preferences`.

Before running the app:

1. Create a Firebase project and enable **Authentication > Sign-in method >
   Email/Password**.
2. Install the FlutterFire CLI and run `flutterfire configure` from the project
   root. This creates the platform Firebase configuration required by
   `Firebase.initializeApp()`.
3. Run `flutter pub get`, then `flutter run`.

The profile screen is available from the account icon in the dashboard. Changing
an email address or password requires the current password because Firebase
requires recent authentication for those operations.

## Auth feature architecture

The auth feature follows a feature-first clean architecture:

- `domain/` contains the `AuthUser` entity, repository contract, failure type,
  and sign-in, registration, profile-update, and sign-out use cases. It has no
  Firebase or Flutter dependencies.
- `data/` contains Firebase and `SharedPreferences` data sources, the Firebase
  user model, and `AuthRepositoryImpl`, which maps external errors to domain
  failures and persists the session.
- `presentation/` contains the Cubit and screens. The Cubit depends only on
  domain contracts and use cases; Firebase is wired in `app/app.dart`.
