# Env Builder CLI - Comprehensive Documentation

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Installation](#installation)
4. [Quick Start](#quick-start)
5. [Commands](#commands)
    5.1. [Build Command](#build-command)
    5.2. [Encrypt Command](#encrypt-command)
    5.3. [Decrypt Command](#decrypt-command)
    5.4. [APK Build Command](#apk-build-command)
    5.5. [AAB Build Command](#aab-build-command)
    5.6. [Assets Command](#assets-command)
    5.7. [Version Command](#version-command)
6. [Configuration](#configuration)
7. [Generated Code Structure](#generated-code-structure)
8. [API Reference](#api-reference)
9. [Examples](#examples)
10. [Security](#security)
11. [Troubleshooting](#troubleshooting)
12. [Contributing](#contributing)
13. [License](#license)

## Overview

**Env Builder CLI** is a powerful Dart command-line tool that automates the creation and maintenance of environment packages for Flutter applications. It generates type-safe environment variable access from `.env` files with built-in encryption support, eliminating the need for manual environment configuration management.

### Key Features

- 🚀 **Automated Environment Package Generation**: Automatically creates Flutter packages from `.env` files
- 🔐 **Built-in Encryption**: AES encryption support for sensitive environment variables
- 📝 **Type-Safe Access**: Generates Dart classes using [Envied](https://pub.dev/packages/envied) for compile-time safety
- 🏗️ **Flutter Integration**: Seamlessly integrates with Flutter projects and handles pubspec dependencies
- 🔄 **Multi-Environment Support**: Handle development, staging, production, and custom environments
- 📂 **Git Integration**: Automatic `.gitignore` updates with appropriate environment file rules
- 🧪 **Testing Support**: Generates test files for environment variable validation
- ⚡ **Build Runner Integration**: Automatic code generation with build_runner

### What It Solves

Traditional Flutter environment management often involves:
- Manual creation of environment classes
- Error-prone string-based variable access
- Inconsistent environment handling across flavors
- Security risks with plaintext sensitive data

Env Builder CLI addresses these issues by:
- Generating compile-time safe environment access
- Providing consistent APIs across all environments
- Supporting encryption for sensitive variables
- Automating the entire setup process

## Architecture

### Core Components

The CLI is built around several key architectural components:

```
env_builder_cli/
├── bin/
│   └── env_builder_cli.dart          # CLI entry point
├── lib/
│   ├── src/
│   │   ├── env_builder.dart          # Main interface
│   │   ├── env_builder_cli.dart      # Concrete implementation
│   │   ├── bin/
│   │   │   ├── commands/             # CLI commands
│   │   │   │   ├── build_command.dart
│   │   │   │   ├── encrypt_command.dart
│   │   │   │   ├── decrypt_command.dart
│   │   │   │   └── version_command.dart
│   │   │   └── [supporting classes]
│   │   └── core/                     # Core functionality
│   │       ├── code_generator.dart   # Dart code generation
│   │       ├── env_file_parser.dart  # .env file parsing
│   │       ├── env_crypto.dart       # Encryption/decryption
│   │       ├── file_system_manager.dart # File operations
│   │       ├── naming_utils.dart     # Naming conventions
│   │       ├── process_runner.dart   # External process execution
│   │       ├── yaml_manager.dart     # YAML file management
│   │       └── text_templates.dart   # UI text templates
```

### Data Flow

1. **Input Processing**: CLI arguments are parsed and validated
2. **File Discovery**: Environment files are located and validated
3. **Code Generation**: Dart classes are generated from .env content
4. **Package Creation**: Flutter package structure is created
5. **Dependency Management**: pubspec.yaml files are updated
6. **Build Execution**: build_runner generates final code

### Dependencies

- **args**: Command-line argument parsing
- **cli_util**: CLI utilities
- **crypto**: Cryptographic functions
- **encrypt**: AES encryption/decryption
- **path**: Cross-platform path handling
- **universal_io**: Platform-agnostic I/O operations
- **yaml/yaml_edit**: YAML parsing and manipulation

## Installation

### Global Installation

Install the CLI globally using pub:

```bash
dart pub global activate env_builder_cli
```

Or using the executable name:

```bash
dart pub global activate env_builder
```

### Local Installation

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  env_builder_cli: ^1.1.5
```

### Verification

Verify installation:

```bash
env_builder --version
# or
env_builder version
```

## Quick Start

### 1. Create Environment Files

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

### 2. Run Build Command

```bash
env_builder build --env-file=.env.development,.env.production,.env.staging
```

This creates:
- `packages/env/` directory with generated Flutter package
- Type-safe Dart classes for environment access
- Updated `pubspec.yaml` with env package dependency
- Automatic `flutter pub get` execution

### 3. Use in Your Flutter App

```dart
import 'package:env/env.dart';

void main() {
  final appFlavor = AppFlavor.production();
  final baseUrl = appFlavor.getEnv(Env.baseUrl);
  final apiKey = appFlavor.getEnv(Env.apiKey);
}
```

## Commands

### Build Command

Generates environment packages from `.env` files.

**Usage:**
```bash
env_builder build [options]
```

**Options:**
- `--env-file, -e`: Specify environment files (comma-separated)
- `--output-dir`: Custom output directory (default: `packages/env`)
- `--no-encrypt`: Skip encryption prompts
- `--verbose`: Detailed output

**Examples:**
```bash

# Build specific files
env_builder build --env-file=.env.dev,.env.prod

# Build with custom output
env_builder build --output-dir=custom_env
```

**What it does:**
1. Scans for `.env*` files (or uses specified files)
2. Creates `packages/env/` directory structure
3. Copies environment files to the package
4. Generates Dart classes with Envied annotations
5. Updates pubspec.yaml files
6. Runs `flutter pub get`
7. Executes `build_runner build` for code generation
8. Prompts for encryption of sensitive files

### Encrypt Command

Encrypts environment files using AES encryption.

**Usage:**
```bash
env_builder encrypt --password=<key> <file>
```

**Example:**
```bash
env_builder encrypt --password=mySecretKey .env.production
```

Creates `.env.production.encrypted` file.

### Decrypt Command

Decrypts previously encrypted environment files.

**Usage:**
```bash
env_builder decrypt --password=<key> <file>
```

**Example:**
```bash
env_builder decrypt --password=mySecretKey .env.production.encrypted
```

### APK Build Command

Build Flutter APK with release obfuscation and debug symbol generation.

**Usage:**
```bash
env_builder apk [options]
```

**Options:**
- `--target, -t`: Target main Dart file path (default: `lib/main.dart`)

**Examples:**
```bash
# Build APK with default settings
env_builder apk

# Build APK with custom target
env_builder apk --target=lib/main_production.dart
```

**What it does:**
1. Executes `flutter build apk` with release configuration
2. Applies obfuscation to protect code
3. Generates debug symbols for crash analysis
4. Stores symbols in `build/app/outputs/symbols/`

### AAB Build Command

Build Flutter AAB (Android App Bundle) with release obfuscation and debug symbol generation.

**Usage:**
```bash
env_builder aab [options]
```

**Options:**
- `--target, -t`: Target main Dart file path (default: `lib/main.dart`)

**Examples:**
```bash
# Build AAB with default settings
env_builder aab

# Build AAB with custom target
env_builder aab --target=lib/main_production.dart
```

**What it does:**
1. Executes `flutter build appbundle` with release configuration
2. Applies obfuscation to protect code
3. Generates debug symbols for crash analysis
4. Stores symbols in `build/app/outputs/symbols/`
5. Creates optimized AAB for Google Play distribution

### Assets Command

Encrypts and embeds assets directly in your Dart code.

**Usage:**
```bash
env_builder assets [options]
```

**Options:**
- `--encrypt, -e`: Encryption method (`xor` or `aes`, default: `xor`)
- `--no-compress`: Disable image compression and SVG minification
- `--verbose`: Detailed output during generation

**Examples:**
```bash
# Generate encrypted assets with XOR encryption (default)
env_builder assets

# Use AES encryption instead
env_builder assets --encrypt=aes

# Disable compression and show detailed output
env_builder assets --no-compress --verbose
```

**What it does:**
1. Scans the `assets/` directory for supported files
2. Applies compression to images and minification to SVGs (unless disabled)
3. Encrypts asset data using the specified method
4. Generates Dart files with embedded encrypted assets:
   - `lib/src/generated/assets.g.dart`: Raw encrypted data access
   - `lib/src/generated/assets.widgets.g.dart`: Pre-built widgets
   - `lib/src/generated/assets.gen.dart`: Flutter_gen compatible API
5. Creates `build.yaml` with asset generation configuration
6. Updates project structure for zero-runtime dependencies

**Supported Asset Types:**
- **Images**: PNG, JPG, JPEG, GIF, WebP
- **Videos**: MP4, WebM, MOV, AVI, MKV
- **SVGs**: SVG files with automatic minification

**Encryption Options:**
- **XOR**: Fast, lightweight encryption (recommended for most cases)
- **AES**: Slower but more secure encryption (use for highly sensitive assets)

**Generated Code Examples:**

```dart
// assets.g.dart - Raw encrypted data access
final logoBytes = Assets.logo; // Uint8List
final iconSvg = Assets.icon; // String
final videoBytes = Assets.videoIntro; // Uint8List

// assets.widgets.g.dart - Pre-built widgets
final logoImage = Assets.logoImage(); // Image widget
final iconSvg = Assets.iconSvg(); // SvgPicture widget
final videoController = Assets.videoIntroController(); // Future<VideoPlayerController>

// assets.gen.dart - Flutter_gen compatible API
final logoImage = Assets.images.logo; // AssetGenImage
final iconSvg = Assets.svgs.icon; // SvgGenImage
final videoPlayer = Assets.videos.intro; // VideoGenImage
```

### Version Command

Displays version information.

**Usage:**
```bash
env_builder version
# or
env_builder --version
```

**Output:**
- CLI version
- Dart SDK version
- Tool description
- Repository URL

## Configuration

### Environment File Format

Environment files follow standard `.env` format:

```bash
# Comments start with #
KEY_NAME=value
QUOTED_VALUE="quoted value"
MULTILINE_VALUE="line one\nline two"
```

**Supported formats:**
- `KEY=value`
- `KEY="quoted value"`
- `KEY='single quoted'`
- Comments with `#`
- Empty lines (ignored)

### Naming Conventions

The tool uses specific naming conventions:

- **Environment files**: `.env.<flavor>` (e.g., `.env.development`)
- **Generated classes**: `Env<Flavor>` (e.g., `EnvDevelopment`)
- **Dart files**: `env.<suffix>.dart` (e.g., `env.development.dart`)
- **Variables**: `SCREAMING_SNAKE_CASE` → `camelCase`

### Project Structure

After running `env_builder build`:

```
your-flutter-project/
├── packages/
│   └── env/
│       ├── .env.development
│       ├── .env.production
│       ├── lib/
│       │   └── src/
│       │       ├── env.development.dart
│       │       ├── env.production.dart
│       │       ├── env.dart (enum definitions)
│       │       └── app_flavor.dart
│       ├── env.dart (barrel export)
│       ├── pubspec.yaml
│       └── test/
│           └── env_test.dart
├── .env.development
├── .env.production
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   └── icon.svg
│   └── videos/
│       └── intro.mp4
├── lib/
│   └── src/
│       └── generated/
│           ├── assets.g.dart (encrypted asset data)
│           ├── assets.widgets.g.dart (widget helpers)
│           └── assets.gen.dart (flutter_gen compatible API)
├── build.yaml (asset generation configuration)
├── pubspec.yaml (updated with env dependency)
└── .gitignore (updated with env rules)
```

## Generated Code Structure

### Environment Classes

Generated classes use the [Envied](https://pub.dev/packages/envied) package for compile-time code generation:

```dart
// env.development.dart
import 'package:envied/envied.dart';

part 'env.development.g.dart';

@Envied(path: '.env.development', obfuscate: true)
abstract class EnvDevelopment {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _EnvDevelopment.baseUrl;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _EnvDevelopment.apiKey;
}
```

### Enum Definitions

```dart
// env.dart
enum Env {
  baseUrl('BASE_URL'),
  apiKey('API_KEY');

  const Env(this.name);
  final String name;
}

typedef EnvValue = String Function(Env env);
```

### App Flavor Classes

```dart
// app_flavor.dart
enum Flavor { development, production }

class AppFlavor extends AppEnv {
  factory AppFlavor.development() => const AppFlavor._(flavor: Flavor.development);
  factory AppFlavor.production() => const AppFlavor._(flavor: Flavor.production);

  const AppFlavor._({required this.flavor});
  final Flavor flavor;

  @override
  String getEnv(Env env) => switch(env){
    Env.baseUrl => switch(flavor){
      Flavor.development => EnvDevelopment.baseUrl,
      Flavor.production => EnvProduction.baseUrl,
    },
    // ... other env vars
  };
}
```

## API Reference

### EnvBuilder Interface

Abstract interface defining the contract for environment building:

```dart
abstract class EnvBuilder {
  // Naming utilities
  String generateEnvClassName(String envFileName);
  String generateEnvDartFileName(String envFileName);
  String envDartFileSuffix(String fileName);
  String toCamelCase(String input);
  String capitalizeFirst(String input);
  String getFlavor(String fileName);

  // Code generation
  String generateEnvClassContent(String envFileName, String envClassName, File envFile);
  String generateEnumClassContent(File file);
  String generateAppFlavorContent(List<String> paths);
  String fileExporter(String suffix);

  // File operations
  Map<String, String> parseEnvFile(File file);
  Future<void> createGitignoreWithEnvEntries({String path, bool includeFlutterDefaults, bool keepExample});
  void writeEnvTestFile(String path);

  // Package management
  void updatePubspecYaml(File pubspecFile, String path);
  void updateRootPubspecWithEnvPackage(String rootPubspecPath);

  // Process execution
  Future<ProcessResult> flutterCommand(List<String> arguments, {String? path, String engine});

  // UI
  void printUsage();
}
```

### EnvBuilderCli Implementation

Concrete implementation of `EnvBuilder` with full functionality.

### Core Classes

#### CodeGenerator
Handles all Dart code generation:
- Environment classes with Envied annotations
- Enum definitions
- App flavor classes
- Test file templates

#### EnvFileParser
Parses `.env` files according to standard format:
- Ignores comments and empty lines
- Handles quoted values
- Supports various quote types

#### EnvCrypto
Manages encryption/decryption operations:
- AES encryption for sensitive files
- Password-based key derivation
- File I/O for encrypted content

#### FileSystemManager
Handles file system operations:
- Directory creation
- File copying
- Gitignore management

#### NamingUtils
Provides naming convention utilities:
- CamelCase conversion
- Class name generation
- File suffix extraction

#### ProcessRunner
Executes external processes:
- Flutter commands
- Dart commands
- Build runner execution

#### YamlManager
Manages YAML file operations:
- pubspec.yaml updates
- Dependency management
- Package configuration

## Examples

### Basic Usage

```dart
import 'package:env/env.dart';

class ApiService {
  final appFlavor = AppFlavor.production();

  Future<void> login(String username, String password) async {
    final baseUrl = appFlavor.getEnv(Env.baseUrl);
    final apiKey = appFlavor.getEnv(Env.apiKey);

    final response = await http.post(
      Uri.parse('$baseUrl${appFlavor.getEnv(Env.loginUrl)}'),
      headers: {'Authorization': 'Bearer $apiKey'},
      body: {'username': username, 'password': password},
    );
  }
}
```

### Flavor-Specific Configuration

```dart
void main() {
  // Determine flavor at runtime
  const flavor = String.fromEnvironment('FLAVOR');

  late final AppFlavor appFlavor;
  switch (flavor) {
    case 'development':
      appFlavor = AppFlavor.development();
      break;
    case 'production':
      appFlavor = AppFlavor.production();
      break;
    default:
      appFlavor = AppFlavor.development();
  }

  runApp(MyApp(appFlavor: appFlavor));
}
```

### Using EnvValue Type

```dart
class UserService {
  UserService(this.env);

  final EnvValue env;

  Future<User> createUser(String name, String email) async {
    final url = '${env(Env.baseUrl)}${env(Env.createUserUrl)}';
    final apiKey = env(Env.apiKey);

    // Make API call...
  }
}

// Usage
final userService = UserService(AppFlavor.production().getEnv);
```

### Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:env/env.dart';

void main() {
  group('Environment Configuration', () {
    test('should load production environment', () {
      final appFlavor = AppFlavor.production();
      final baseUrl = appFlavor.getEnv(Env.baseUrl);

      expect(baseUrl, isNotEmpty);
      expect(baseUrl, startsWith('https://'));
    });

    test('should have different values for different flavors', () {
      final devFlavor = AppFlavor.development();
      final prodFlavor = AppFlavor.production();

      expect(
        devFlavor.getEnv(Env.baseUrl),
        isNot(equals(prodFlavor.getEnv(Env.baseUrl))),
      );
    });
  });
}
```

### Using Encrypted Assets

After running `env_builder assets`, you can use encrypted assets in your Flutter widgets:

```dart
import 'package:flutter/material.dart';
import 'package:my_app/src/generated/assets.gen.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encrypted Assets Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Using encrypted image with pre-built widget
          Assets.images.logoImage(),

          // Using encrypted SVG with custom styling
          Assets.svgs.iconSvg(),

          // Using encrypted video with FutureBuilder
          FutureBuilder<VideoPlayer>(
            future: Assets.videos.intro.video(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(height: 200, child: snapshot.data);
              }
              return CircularProgressIndicator();
            },
          ),

          // Using raw encrypted data for custom processing
          FutureBuilder<Uint8List>(
            future: _decryptAsset(Assets.logo),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(snapshot.data!);
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _decryptAsset(Uint8List encryptedData) async {
    // Custom decryption logic if needed
    // Implementation depends on your encryption method
    return encryptedData; // Placeholder
  }
}
```

## Security

### Best Practices

1. **Never commit .env files**
   ```bash
   # .gitignore
   .env*
   !.env.example
   ```

2. **Use encryption for production secrets**
   ```bash
   env_builder build  # Follow encryption prompts
   ```

3. **Store encryption keys securely**
   - Use environment variables for keys
   - Store keys in secure credential managers
   - Rotate keys regularly

4. **Use different keys per environment**
   ```bash
   # Different keys for dev/staging/prod
   DEV_ENCRYPTION_KEY=dev_key_123
   PROD_ENCRYPTION_KEY=prod_key_456
   ```

### Encryption Flow

1. Build command identifies sensitive variables
2. Prompts user for encryption decision
3. If encryption chosen:
   - Requests encryption password
   - Encrypts .env files using AES
   - Deletes original plaintext files
   - Updates generated code to use encrypted paths

### Security Features

- **Obfuscation**: Envied automatically obfuscates sensitive values
- **Encryption**: AES encryption for entire files
- **Access Control**: Compile-time safe access prevents typos
- **Git Integration**: Automatic .gitignore updates

## Troubleshooting

### Common Issues

#### "No .env* files found"
**Problem**: No environment files in current directory
**Solution**:
```bash
# Check current directory
ls -la | grep .env

# Specify files explicitly
env_builder build --env-file=.env.development,.env.production
```

#### "build_runner build failed"
**Problem**: Code generation failed
**Solution**:
```bash
# Clean and rebuild
cd packages/env
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build
```

#### "Target of URI doesn't exist: 'package:env/env.dart'"
**Problem**: Package not properly imported
**Solution**:
```bash
# Ensure pubspec.yaml includes env dependency
flutter pub get

# Check packages/env exists and is properly structured
ls -la packages/env
```

#### "Encryption password mismatch"
**Problem**: Wrong password used for decryption
**Solution**:
- Verify password is correct
- Check for typos in password entry
- Ensure same password used for encrypt/decrypt operations

### Debug Mode

Enable verbose output for troubleshooting:

```bash
env_builder build --verbose
```

### Manual Cleanup

If build fails, clean up manually:

```bash
# Remove generated package
rm -rf packages/env

# Reset pubspec.yaml
git checkout pubspec.yaml

# Clean build artifacts
flutter clean
flutter pub get
```

### Version Compatibility

Ensure compatible versions:
- Dart SDK: ^3.8.1
- Flutter: Compatible with your project
- Envied: Latest version (managed by tool)

## Contributing

### Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/KalybosPro/env_builder_cli.git
   cd env_builder_cli
   ```

2. **Install dependencies**
   ```bash
   dart pub get
   ```

3. **Run tests**
   ```bash
   dart test
   ```

4. **Run example**
   ```bash
   cd example
   flutter pub get
   dart run ../bin/env_builder_cli.dart build --env-file=.env.ci
   flutter run
   ```

### Code Structure

- **bin/**: CLI entry points
- **lib/src/bin/**: Command implementations and supporting logic
- **lib/src/core/**: Core business logic
- **test/**: Unit tests
- **example/**: Usage examples

### Testing

Run the full test suite:

```bash
dart test
```

Run tests with coverage:

```bash
dart test --coverage=coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

### Code Style

Follow Dart style guidelines:

```bash
# Format code
dart format .

# Analyze code
dart analyze

# Run lints
dart run custom_lint
```

### Pull Request Process

1. Create a feature branch
2. Write tests for new functionality
3. Ensure all tests pass
4. Update documentation if needed
5. Submit PR with clear description

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Made with ❤️ for the Flutter community**

For more information, visit the [GitHub repository](https://github.com/KalybosPro/env_builder_cli).
