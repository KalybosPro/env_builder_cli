# Env Builder CLI

`env_builder_cli` is a Dart CLI tool designed to automate the creation and maintenance of a Flutter package named `env` inside a `packages/` folder. It helps Flutter developers manage multiple `.env` environment files by generating Dart code with [Envied](https://pub.dev/packages/envied) annotations, updating package dependencies, and managing Flutter project integration seamlessly.

---

## Features

- Accept multiple `.env` files (e.g. `.env.development`, `.env.production`, `.env.staging`, etc.).
- Create the `packages/` directory if it does not exist.
- Create or update a Flutter package `env` within `packages/env`.
- Copy all specified `.env.*` files into `packages/env/`.
- Generate Dart files (`env.dev.dart`, `env.prod.dart`, `env.stg.dart`, etc.) within `lib/src/`.
- Generate `lib/src/env.dart` exporting all generated environment Dart files.
- Create or update `pubspec.yaml` inside `packages/env` with required dependencies.
- Automatically modify the root Flutter project’s `pubspec.yaml` to include `env` as a path dependency.
- Run `flutter pub get` automatically in the root project after setup.
- Minimal and clear command-line output.

---

## Prerequisites

- Dart SDK version **3.8.1**
- Flutter SDK installed and added to your system path (for running `flutter` commands).
- Your Flutter project root directory (with an existing `pubspec.yaml`) contains the `.env.*` files you want to use.

---

## Installing

```dart
dart run global activate env_builder_cli

```

## Usage

Create your `.env.*` files (e.g: `.env`, `.env.development`, `.env.production`, `.env.staging`, etc) inside your Flutter project's root and specify all your necessaries keys and values inside them.

Ex:

```env

# App settings
BASE_URL = https://api.example.com/
API_KEY = supersecret

# Routes
LOGIN_URL = "login"
REGISTER_URL = "register/user"

```

## Command

You specify all the .env files that you want to use by separating the with comma.

```dart

env_builder --env-file=.env

```

Or

```dart

env_builder --env-file=.env.development, .env.production, .env.staging

```

Or

```dart

env_builder --env-file=.env.development

```

Wait till `env_builder` take care of everything for you.
Now, you can use your environment variables inside your application.

Ex:

```dart
final appFlavor = AppFlavor.production();

class ApiService {
    final appBaseUrl = appFlavor.getEnv(Env.baseUrl);
    final apikey = appFlavor.getEnv(Env.apiKey);
}

```