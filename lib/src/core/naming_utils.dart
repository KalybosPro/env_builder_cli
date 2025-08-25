import 'core.dart';

/// Utility class for string manipulation and naming conventions
class NamingUtils {
  /// Capitalizes the first letter of a string
  static String capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  /// Converts snake_case to camelCase
  static String toCamelCase(String input) {
    final parts = input.toLowerCase().split('_');
    if (parts.isEmpty) return '';

    return parts.first +
        parts.skip(1).map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        }).join();
  }

  /// Generates a readable comment from a key
  static String generateCommentFromKey(String key) {
    final readable = key
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAllMapped(
          RegExp(r'\b\w'),
          (match) => match.group(0)!.toUpperCase(),
        );
    return 'The value for $readable.';
  }

  /// Extracts environment type from filename
  static String _extractEnvironmentType(String fileName) {
    final lower = fileName.toLowerCase();
    for (final env in EnvConfig.environmentMappings.keys) {
      if (lower.contains(env)) return env;
    }
    return 'production'; // default
  }

  /// Gets environment suffix from filename
  static String getEnvironmentSuffix(String fileName) {
    final envType = _extractEnvironmentType(fileName);
    return EnvConfig.environmentMappings[envType] ?? 'prod';
  }

  /// Gets environment class name from filename
  static String getEnvironmentClassName(String fileName) {
    final envType = _extractEnvironmentType(fileName);
    return EnvConfig.classNameMappings[envType] ?? 'EnvProd';
  }

  /// Gets environment dart filename from env filename
  static String getEnvironmentDartFileName(String fileName) {
    final envType = _extractEnvironmentType(fileName);
    return EnvConfig.fileNameMappings[envType] ?? 'env.prod.dart';
  }

  /// Gets flavor name from filename
  static String getFlavor(String fileName) {
    return _extractEnvironmentType(fileName);
  }
}
