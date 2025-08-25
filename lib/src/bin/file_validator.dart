import '../core/core.dart';

/// Handles file and directory validation
class FileValidator {
  /// Validates that all environment files exist
  static void validateEnvFiles(List<String> envFilePaths) {
    for (final envFilePath in envFilePaths) {
      final envFile = File(envFilePath);
      if (!envFile.existsSync()) {
        throw FileSystemException('Env file does not exist: $envFilePath');
      }
    }
  }
}
