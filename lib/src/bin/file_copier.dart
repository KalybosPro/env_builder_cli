// ignore_for_file: avoid_print

import '../core/core.dart';
import 'package:path/path.dart' as p;
import 'commands/build_command.dart';

/// Handles file copying operations
///
/// Manages the copying of .env files from source locations to the
/// destination environment package directory, maintaining a track
/// of copied files for potential future operations like encryption.
class FileCopier {
  static List<String> get envFiles => _envFiles;
  static List<String> _envFiles = [];

  /// Copies environment files to the package directory with optimized batch operations
  static Future<void> copyEnvFiles(
    List<String> envFilePaths,
    Directory envPackageDir,
  ) async {
    _envFiles = List<String>.filled(envFilePaths.length, '', growable: false);
    final futures = <Future<void>>[];

    for (var i = 0; i < envFilePaths.length; i++) {
      futures.add(_copyEnvFile(envFilePaths[i], envPackageDir, i));
    }

    await Future.wait(futures);
  }

  static Future<void> _copyEnvFile(
    String envFilePath,
    Directory envPackageDir,
    int index,
  ) async {
    final envFile = File(envFilePath);
    final fileName = p.basename(envFilePath);
    final destinationPath = p.join(envPackageDir.path, fileName);
    final destinationFile = File(destinationPath);

    try {
      await envFile.copy(destinationFile.path);
      _envFiles[index] = destinationFile.path;
      if (BuildCommand.isVerbose) {
        print('Copied $fileName file to ${destinationFile.path}');
      }
    } catch (e) {
      throw FileSystemException(
        'Error copying $envFilePath to ${destinationFile.path}: $e',
      );
    }
  }
}
