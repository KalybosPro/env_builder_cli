import '../core/core.dart';
import 'package:path/path.dart' as p;

/// Handles file copying operations
class FileCopier {
  /// Copies environment files to the package directory
  static Future<void> copyEnvFiles(
    List<String> envFilePaths,
    Directory envPackageDir,
  ) async {
    for (final envFilePath in envFilePaths) {
      await _copyEnvFile(envFilePath, envPackageDir);
    }
  }

  static Future<void> _copyEnvFile(
    String envFilePath,
    Directory envPackageDir,
  ) async {
    final envFile = File(envFilePath);
    final fileName = p.basename(envFilePath);
    final destinationPath = p.join(envPackageDir.path, fileName);
    final destinationFile = File(destinationPath);
    
    try {
      await envFile.copy(destinationFile.path);
      print('Copied env file to ${destinationFile.path}');
    } catch (e) {
      throw FileSystemException(
        'Error copying $envFilePath to ${destinationFile.path}: $e'
      );
    }
  }
}
