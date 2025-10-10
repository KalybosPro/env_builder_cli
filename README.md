# Env Builder CLI

[![Pub Version](https://img.shields.io/pub/v/env_builder_cli.svg)](https://pub.dev/packages/env_builder_cli)
[![License: Apache](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)


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
dart pub global activate env_builder_cli

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

## Environment File Encryption / Decryption

This CLI provides a simple and secure way to encrypt and decrypt your environment files (.env).
It helps protect sensitive information such as API keys, database credentials, and tokens when sharing code or committing to a repository.

## Features

- AES-based encryption with a password-derived key.
- CLI commands for quick usage (encrypt / decrypt).
- Compatible with .env files of any size.

## Usage

1. Encrypt a file

```bash

env_builder encrypt .env .env.enc --password superSecretKey
```

- `.env` → input file (plaintext environment file).
- `.env.enc` → output file (encrypted file).
- `--password` → secret used to derive the encryption key.

Result:

- A `.env.enc` file is created.
- Can be stored safely in your repo.

2. Decrypt a file

```bash

env_builder decrypt .env.enc .env --password superSecretKey
```

- `.env.enc` → input file (encrypted file).
- `.env` → output file (restored plaintext file).
- `--password` → must be the same password used during encryption.

Result:

- The original `.env` file is restored.

## Notes

- If the password does not match or the file is corrupted, you’ll get:
```javascript

Error: Invalid password or corrupted file.
```
- For production use, always use a strong and private password.
- Do not commit decrypted `.env` files to version control. Only commit the encrypted version (`.env.enc`).

## Example Workflow

```bash

# Encrypt your .env before committing
env_builder encrypt .env .env.enc --password superSecretKey12345

# Remove the plaintext file (optional)
rm .env

# Later, restore it locally
env_builder decrypt .env.enc .env --password superSecretKey12345
```

With this, your team can safely share the .env.enc file while keeping secrets protected.