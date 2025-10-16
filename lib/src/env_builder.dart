// ignore_for_file: avoid_print

import 'package:universal_io/io.dart';

/// Abstract interface for environment builder functionality
///
/// Defines the contract for building and managing environment variables
/// in Flutter applications, enabling type-safe access through generated
/// Dart classes and encrypted storage of sensitive configuration.
abstract class EnvBuilder {
  /// Returns env class name for the env.* file, e.g. EnvDev, EnvProd, EnvStg
  String generateEnvClassName(String envFileName);

  /// Returns env Dart file name to create, e.g. env.dev.dart
  String generateEnvDartFileName(String envFileName);

  /// Returns suffix for generated env Dart files, e.g., 'dev' for env.dev.dart
  String envDartFileSuffix(String fileName);

  /// Generates Dart code for individual env.*.dart files
  String generateEnvClassContent(
    String envFileName,
    String envClassName,
    File envFile,
  );

  /// Here's a Dart function to convert a string like API_KEY (SCREAMING_SNAKE_CASE) into apiKey (camelCase
  String toCamelCase(String input);

  /// Creates or updates the 'packages/env/pubspec.yaml' with envied dependencies and plugin platforms.
  void updatePubspecYaml(File pubspecFile, String path);

  /// Updates the root Flutter project's pubspec.yaml to add env package as a path dependency without duplication.
  void updateRootPubspecWithEnvPackage(String rootPubspecPath);

  /// Display env_builder_cli usage
  void printUsage();

  /// Parse .env file, ignoring empty lines and comments, and handling quoted strings correctly
  Map<String, String> parseEnvFile(File file);

  /// Creates or updates a `.gitignore` file with Dart/Flutter and .env rules.
  Future<void> createGitignoreWithEnvEntries({
    String path = '.gitignore',
    bool includeFlutterDefaults = true,
    bool keepExample = true,
  });

  /// Convert a String so that only the first character is uppercase and the rest are lowercase
  String capitalizeFirst(String input);

  /// To execute Flutter command
  Future<ProcessResult> flutterCommand(
    List<String> arguments, {
    String? path,
    String engine = 'flutter',
  });

  /// Export files helper
  String fileExporter(String suffix);

  /// Generate the content of the enums file
  /// Create the enum class that takes the key as value
  String generateEnumClassContent(File file);

  /// Generate app flavor content.
  /// Help to determine the mode: development, production or staging
  String generateAppFlavorContent(List<String> paths);

  /// Returns the exact flavor for .env.* file, e.g: development, production, staging
  String getFlavor(String fileName);

  /// Update test/env_test.dart file
  void writeEnvTestFile(String path);
}
