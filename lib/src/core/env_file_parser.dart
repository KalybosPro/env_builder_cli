// ignore_for_file: avoid_print

import 'core.dart';

/// Handles .env file parsing operations with optimized performance
///
/// Parses environment files according to standard .env file format:
/// - Ignores comment lines starting with #
/// - Trims whitespace from keys and values
/// - Removes surrounding quotes from values
/// - Handles key-value pairs separated by =
/// - Optimized parsing with minimal allocations
class EnvFileParser {
  static const int doubleQuote = 0x22;
  static const int singleQuote = 0x27;
  static const int hash = 0x23;

  /// Parses an .env file and returns key-value pairs with optimized performance
  static Map<String, String> parseEnvFile(File file) {
    final Map<String, String> envVars = <String, String>{};

    final lines = file.readAsLinesSync();
    for (final line in lines) {
      final length = line.length;
      if (length == 0 || line.codeUnitAt(0) == hash) continue;

      final index = line.indexOf('=');
      if (index == -1 || index == 0) continue;

      final key = line.substring(0, index).trim();
      if (key.isEmpty) continue;

      var value = line.substring(index + 1).trim();

      // Fast quote removal without regex
      if (value.length >= 2) {
        final firstChar = value.codeUnitAt(0);
        final lastChar = value.codeUnitAt(value.length - 1);
        if ((firstChar == doubleQuote || firstChar == singleQuote) &&
            firstChar == lastChar) {
          value = value.substring(1, value.length - 1);
        }
      }

      envVars[key] = value;
    }

    return envVars;
  }
}
