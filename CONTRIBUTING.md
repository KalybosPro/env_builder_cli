# Contributing to Env Builder CLI

Thank you for your interest in contributing to Env Builder CLI! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Code Style](#code-style)
- [Submitting Changes](#submitting-changes)
- [Reporting Issues](#reporting-issues)
- [Documentation](#documentation)

## Code of Conduct

This project has adopted a Code of Conduct to ensure a welcoming and inclusive environment for all contributors. By participating in this project, you agree to abide by its terms. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for details.

## Getting Started

### Prerequisites

Before you begin, ensure you have:

- **Dart SDK**: Version 3.8.1 or higher
- **Flutter SDK**: Latest stable version
- **Git**: Version control system
- **Terminal/Command Line**: Basic command line knowledge

### Development Setup

1. **Fork and Clone the Repository**

   ```bash
   # Fork the repository on GitHub
   # Then clone your fork
   git clone https://github.com/YOUR_USERNAME/env_builder_cli.git
   cd env_builder_cli
   ```

2. **Install Dependencies**

   ```bash
   # Install project dependencies
   dart pub get
   ```

3. **Verify Setup**

   ```bash
   # Run tests to ensure everything works
   dart test

   # Build the CLI to verify compilation
   dart compile exe bin/env_builder_cli.dart
   ```

## Project Structure

```
env_builder_cli/
├── bin/
│   └── env_builder_cli.dart         # CLI entry point
├── lib/
│   ├── src/
│   │   ├── bin/
│   │   │   ├── commands/            # CLI commands
│   │   │   │   ├── build_command.dart
│   │   │   │   ├── encrypt_command.dart
│   │   │   │   └── decrypt_command.dart
│   │   │   └── cli_config.dart      # CLI configuration
│   │   ├── core/                    # Core business logic
│   │   │   ├── code_generator.dart  # Code generation
│   │   │   ├── env_crypto.dart      # Encryption/decryption
│   │   │   ├── env_file_parser.dart # .env file parsing
│   │   │   └── process_runner.dart  # External process execution
│   │   └── env_builder_cli.dart     # Main CLI implementation
│   └── env_builder.dart             # Public API interface
├── test/
│   └── env_builder_cli_test.dart    # Unit tests
├── example/                         # Example Flutter project
└── pubspec.yaml                     # Project dependencies
```

### Key Components

- **Commands**: Handle specific CLI operations (build, encrypt, decrypt)
- **Core**: Contains business logic for parsing, generation, and processing
- **Code Generation**: Uses Envied to create type-safe environment classes
- **Configuration**: Manages package setup and dependency injection

## Development Workflow

### 1. Choose an Issue

- Check [GitHub Issues](https://github.com/KalybosPro/env_builder_cli/issues) for available tasks
- Look for issues labeled `good first issue` or `help wanted`
- Comment on the issue to indicate you're working on it

### 2. Create a Feature Branch

```bash
# Create and switch to a feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/issue-number-description
```

### 3. Make Changes

- Write clear, focused commits
- Follow the [code style guidelines](#code-style)
- Add tests for new functionality
- Update documentation as needed

### 4. Test Your Changes

```bash
# Run the full test suite
dart test

# Run specific tests
dart test test/specific_test.dart

# Test the CLI manually
dart run bin/env_builder_cli.dart --help
```

### 5. Update Documentation

- Update README.md if adding new features
- Update this CONTRIBUTING.md if changing contribution process
- Add code comments for complex logic

## Testing

### Running Tests

```bash
# Run all tests
dart test

# Run tests with coverage (if configured)
dart test --coverage=coverage

# Run tests in watch mode
dart test --watch
```

### Writing Tests

- Place tests in the `test/` directory
- Name test files with `_test.dart` suffix
- Use descriptive test names
- Cover both positive and negative scenarios
- Test edge cases and error conditions

Example test structure:

```dart
import 'package:test/test.dart';
import 'package:env_builder_cli/env_builder_cli.dart';

void main() {
  group('BuildCommand', () {
    test('should generate env package from single env file', () async {
      // Arrange
      final command = BuildCommand();

      // Act
      final result = await command.run(['--env-file=.env']);

      // Assert
      expect(result, equals(0));
    });
  });
}
```

### Manual Testing

Test your changes manually using the example project:

```bash
cd example

# Test build command
env_builder build --env-file=.env

# Verify generated package
ls -la packages/env/
```

## Code Style

This project follows Dart's official style guide. Key guidelines:

### Dart Style

- Use `dart format` to format code automatically
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and method names
- Write clear documentation comments

### Code Formatting

```bash
# Format all Dart files
dart format .

# Check formatting without changing files
dart format --set-exit-if-changed .
```

### Linting

```bash
# Run linter
dart analyze

# Fix auto-fixable issues
dart fix --apply
```

### Commit Messages

Use clear, descriptive commit messages:

```
feat: add version checking command
fix: handle empty env files in parser
docs: update build command examples
refactor: simplify env file validation logic
```

## Submitting Changes

### Pull Request Process

1. **Push your branch** to your fork:

   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create a Pull Request** on GitHub:
   - Provide a clear title and description
   - Reference related issues
   - Include screenshots for UI changes
   - Describe testing performed

3. **Pull Request Template**:
   - **Type of change**: Bug fix, feature, documentation, etc.
   - **Description**: What was changed and why
   - **Testing**: How changes were tested
   - **Breaking changes**: Any breaking changes for users

4. **Code Review**:
   - Address reviewer feedback
   - Make requested changes
   - Keep conversations professional

5. **Merge**:
   - Once approved, maintainers will merge your PR
   - Your branch will be automatically deleted

### Review Guidelines

- Be respectful and constructive
- Focus on code quality and maintainability
- Suggest improvements rather than demands
- Acknowledge good work

## Reporting Issues

### Bug Reports

When reporting bugs, please include:

- **Description**: Clear description of the issue
- **Steps to reproduce**: Step-by-step instructions
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Environment**: Dart version, OS, Flutter version
- **Error messages**: Full error output
- **Code examples**: Minimal code to reproduce

### Feature Requests

For new features, include:

- **Description**: What feature you want
- **Use case**: Why it's needed
- **Implementation ideas**: How it could work
- **Alternatives**: Other approaches considered

## Documentation

### README Updates

When adding new features:

- Update the features section in README.md
- Add usage examples
- Include any new command-line flags
- Update troubleshooting section if applicable

### Code Documentation

- Add doc comments for public APIs
- Document complex algorithms
- Explain non-obvious design decisions
- Keep comments up to date with code changes

### API Documentation

Generate API docs for published packages:

```bash
# Generate documentation
dart doc

# View generated docs
open doc/api/index.html
```

## Getting Help

- **Issues**: [GitHub Issues](https://github.com/KalybosPro/env_builder_cli/issues)
- **Discussions**: [GitHub Discussions](https://github.com/KalybosPro/env_builder_cli/discussions)
- **Discord**: Join our community Discord (if available)
- **Email**: Contact maintainers directly for sensitive matters

## Recognition

Contributors are recognized in:

- GitHub repository contributors
- CHANGELOG.md for significant contributions
- Release notes for major features

Thank you for contributing to Env Builder CLI! 🚀
