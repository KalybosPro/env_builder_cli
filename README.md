# Env Builder CLI

[![Pub Version](https://img.shields.io/pub/v/env_builder_cli.svg)](https://pub.dev/packages/env_builder_cli)
[![Build Status](https://img.shields.io/github/actions/workflow/status/KalybosPro/env_builder_cli/build.yml?branch=main)](https://github.com/KalybosPro/env_builder_cli/actions)
[![License: Apache](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Dart SDK](https://img.shields.io/badge/dart-sdk-%3E%3D3.8.1-blue.svg)](https://dart.dev)


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

```shell
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

```shell

env_builder --env-file=.env

```

Or

```shell

env_builder --env-file=.env.development, .env.production, .env.staging

```

Or

```shell

env_builder --env-file=.env.development

```

Wait till `env_builder` takes care of everything for you.
Now, you can use your environment variables inside your application.

Ex:

```dart
/// In development mode, use AppFlavor.development(); => stands for .env.development
/// In production mode, use AppFlavor.production(); => stands for .env.production or .env in case you provide only that one
/// In staging mode, use AppFlavor.staging(); => stands for .env.staging

final appFlavor = AppFlavor.production();

class ApiService {
    final appBaseUrl = appFlavor.getEnv(Env.baseUrl);
    final apikey = appFlavor.getEnv(Env.apiKey);
}

```
- In development mode, use `AppFlavor.development()`. It stands for .env.development
- In production mode, use `AppFlavor.production()`. It stands for .env.production or .env in case you provide only that one.
- In staging mode, use `AppFlavor.staging()`. It stands for .env.staging

NB: you can name you .env.* file whatever you want. But, to call the appropriate AppFlavor, use the word after .env.

Ex:

`.env.word` ==> `AppFlavor.word()`