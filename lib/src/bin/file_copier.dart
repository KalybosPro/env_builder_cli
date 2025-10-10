import '../core/core.dart';
import 'package:path/path.dart' as p;

/// Handles file copying operations
class FileCopier {
  static List<String> get envFiles => _envFiles;
  static List<String> _envFiles = [];

  /// Copies environment files to the package directory
  static Future<void> copyEnvFiles(
    List<String> envFilePaths,
    Directory envPackageDir,
  ) async {
    _envFiles = [];
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
      _envFiles.add(destinationFile.path);
      print('Copied $fileName file to ${destinationFile.path}');
    } catch (e) {
      throw FileSystemException(
        'Error copying $envFilePath to ${destinationFile.path}: $e',
      );
    }
  }
}
