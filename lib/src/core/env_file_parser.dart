import 'core.dart';

/// Handles .env file parsing operations
class EnvFileParser {
  /// Parses an .env file and returns key-value pairs
  static Map<String, String> parseEnvFile(File file) {
    final Map<String, String> envVars = {};

    final lines = file.readAsLinesSync();
    for (final line in lines) {
      final trimmed = line.trim();

      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      final index = trimmed.indexOf('=');
      if (index == -1) continue;

      final key = trimmed.substring(0, index).trim();
      var value = trimmed.substring(index + 1).trim();

      // Remove optional quotes (single or double)
      if ((value.startsWith('"') && value.endsWith('"')) ||
          (value.startsWith("'") && value.endsWith("'"))) {
        value = value.substring(1, value.length - 1);
      }

      envVars[key] = value;
    }

    return envVars;
  }
}
