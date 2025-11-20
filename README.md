# env_builder_cli

[![pub package](https://img.shields.io/pub/v/env_builder_cli.svg)](https://pub.dev/packages/env_builder_cli)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Dart SDK Version](https://img.shields.io/badge/Dart-3.8.1+-blue.svg)](https://dart.dev/)

A powerful Dart CLI tool that automates the creation and maintenance of environment packages for Flutter applications. Generate type-safe environment variable access from `.env` files with built-in encryption support.

## Features

- 🚀 **Automated Environment Package Generation**: Automatically creates Flutter packages from `.env` files
- 🔐 **Built-in Encryption**: AES encryption support for sensitive environment variables
- 📝 **Type-Safe Access**: Generates Dart classes using [Envied](https://pub.dev/packages/envied) for compile-time safety
- 🏗️ **Flutter Integration**: Seamlessly integrates with Flutter projects and handles pubspec dependencies
- 🔄 **Multi-Environment Support**: Handle development, staging, production, and custom environments
- 📂 **Git Integration**: Automatic `.gitignore` updates with appropriate environment file rules
- 🧪 **Testing Support**: Generates test files for environment variable validation

## Installation

### Global Installation

Install the CLI globally using pub:

```bash
dart pub global activate env_builder_cli
```

### Local Installation

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  env_builder_cli: ^1.1.4
```

## Usage

### Basic Usage

Navigate to your Flutter project root and run:

```bash
# Build with all .env* files found in current directory (.env.ci, .env.custom, .env.app, etc.)
env_builder build

# Build with specific environment files
env_builder build --env-file=.env.development,.env.production,.env.staging
```

This will:
1. Create a `packages/env` directory
2. Copy your `.env` files to the env package
3. Generate Dart classes for type-safe access
4. Update dependencies in `pubspec.yaml` files
5. Run `flutter pub get` automatically

### Commands

#### Build Command

Generates environment packages from `.env` files:

```bash
# Build with default configuration (auto-detects .env* files)
env_builder build

# Build with specific environment files
env_builder build --env-file=.env.development,.env.production,.env.staging

# Build with custom output directory (default: env)
env_builder build --output-dir=custom_env

# Skip encryption of sensitive variables
env_builder build --no-encrypt

# Show detailed output during build process
env_builder build --verbose

```

**Planned Features:**
- **Complex Data Types Support**: Handle JSON-like strings (e.g., `APP_CONFIG={"theme":"dark","features":["chat","notifications"]}`)
- `--config-env-file`: Specify a default configuration file for environment-specific settings

#### Encrypt Command

Encrypt sensitive environment files:

```bash
env_builder encrypt --password=yourSecretKey .env
```

#### Decrypt Command

Decrypt previously encrypted environment files:

```bash
env_builder decrypt --password=yourSecretKey .env.encrypted
```

#### APK Build Command

Build Flutter APK with release obfuscation:

```bash
env_builder apk

# Build with custom target
env_builder apk --target=lib/main_development.dart
```

#### AAB Build Command

Build Flutter AAB (Android App Bundle) with release obfuscation:

```bash
env_builder aab

# Build with custom target
env_builder aab --target=lib/main_production.dart
```

#### Version Command

Displays version information:

```bash
env_builder version
# or
env_builder --version
```

**Aliases:**
- `--version`, `-v`

**Displays:**
- CLI version (from pubspec.yaml)
- Dart SDK version
- Tool description
- Homepage URL

### Environment File Format

Create `.env` files in your project root:

```bash
# .env.development
BASE_URL=https://dev-api.example.com
API_KEY=dev_key_123
DEBUG=true

# .env.production
BASE_URL=https://api.example.com
API_KEY=prod_key_456
DEBUG=false
```

### Generated Code

The tool generates type-safe Dart classes:

```dart
// env.development.dart
import 'package:envied/envied.dart';

part 'env.development.g.dart';

@Envied(path: '.env.development')
abstract class EnvDevelopment {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _EnvDevelopment.baseUrl;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _EnvDevelopment.apiKey;

  @EnviedField(varName: 'DEBUG')
  static const bool debug = _EnvDevelopment.debug;
}
```

### Flutter Integration

In your Flutter app, use the generated environments:

```dart
import 'package:env/env.dart';

// Access environment variables
final appFlavor = AppFlavor.production();

class ApiService {
    final appBaseUrl = appFlavor.getEnv(Env.baseUrl);
    final apikey = appFlavor.getEnv(Env.apiKey);
}
```

### Project Structure

After running the build command, your project structure will look like:

```
your-flutter-project/
├── packages/
│   └── env/
│       ├── .env.development
│       ├── .env.production
│       ├── env.development.dart
│       ├── env.production.dart
│       ├── env.dart (barrel export)
│       ├── env.g.dart (enum definitions)
│       └── pubspec.yaml
├── .env.development
├── .env.production
├── pubspec.yaml (updated with env dependency)
└── lib/
    └── main.dart
```

### Security Best Practices

1. **Never commit .env files** - Add them to `.gitignore`
2. **Use encryption** for sensitive production variables
3. **Store secrets securely** in your CI/CD platform
4. **Use different keys** for different environments
5. **Rotate secrets** regularly

## Examples

Check the [`example/`](https://github.com/KalybosPro/env_builder_cli/tree/main/example) directory for a complete working example.

To run the example:

```bash
cd example
flutter pub get
# The .env file already exists
env_builder build
flutter run
```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ for the Flutter community
