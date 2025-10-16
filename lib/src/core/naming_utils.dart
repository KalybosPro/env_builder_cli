// ignore_for_file: avoid_print

import 'core.dart';

/// Utility class for string manipulation and naming conventions
///
/// Provides static methods for converting between different naming
/// conventions commonly used in development (snake_case, camelCase, etc.)
/// and generating environment-specific identifiers.
class NamingUtils {
  /// Capitalizes the first letter of a string and lowercases the rest.
  ///
  /// Example: "HELLO" -> "Hello"
  static String capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  /// Converts snake_case to camelCase.
  ///
  /// Example: "some_key_name" -> "someKeyName"
  static String toCamelCase(String input) {
    final parts = input.toLowerCase().split('_');
    if (parts.isEmpty) return '';

    return parts.first +
        parts.skip(1).map((word) {
          return word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1)
              : '';
        }).join();
  }

  /// Generates a readable comment from a key by converting it to title case.
  ///
  /// Example: "api_key" -> "The value for Api Key."
  static String generateCommentFromKey(String key) {
    final readable = key
        .toLowerCase()
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
    return 'The value for $readable.';
  }

  /// Determines the environment type based on the filename.
  ///
  /// Supports environments defined in [EnvConfig.environmentMappings].
  /// Defaults to 'production' if no match is found.
  static String _extractEnvironmentType(String fileName) {
    final lower = fileName.toLowerCase();
    for (final envType in EnvConfig.environmentMappings.keys) {
      if (lower.contains(envType)) return envType;
    }
    return 'production'; // default
  }

  /// Gets the environment suffix for a given filename.
  ///
  /// Example: ".env.production" -> "prod"
  static String getEnvironmentSuffix(String fileName) {
    final envType = _extractEnvironmentType(fileName);
    return EnvConfig.environmentMappings[envType] ?? 'prod';
  }

  /// Gets the environment class name for a given filename.
  ///
  /// Example: ".env.development" -> "EnvDev"
  static String getEnvironmentClassName(String fileName) {
    final envType = _extractEnvironmentType(fileName);
    return EnvConfig.classNameMappings[envType] ?? 'EnvProd';
  }

  /// Gets the Dart file name for a given environment filename.
  ///
  /// Example: ".env.staging" -> "env.stg.dart"
  static String getEnvironmentDartFileName(String fileName) {
    final envType = _extractEnvironmentType(fileName);
    return EnvConfig.fileNameMappings[envType] ?? 'env.prod.dart';
  }

  /// Gets the flavor name from a filename.
  ///
  /// This is an alias for [_extractEnvironmentType].
  static String getFlavor(String fileName) {
    return _extractEnvironmentType(fileName);
  }
}
