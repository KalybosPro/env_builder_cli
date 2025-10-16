// ignore_for_file: avoid_print

import '../core/core.dart';

/// Handles file and directory validation
///
/// Provides validation utilities to ensure that referenced
/// environment files exist before attempting to process them,
/// preventing runtime errors and improving user experience.
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
