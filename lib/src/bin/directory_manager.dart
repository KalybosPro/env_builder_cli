// ignore_for_file: avoid_print

import '../core/core.dart';
import 'package:path/path.dart' as p;
import 'package:env_builder_cli/env_builder_cli.dart' as env_builder_cli;
import 'cli_config.dart';

/// Handles directory operations
///
/// Manages creation and validation of directory structures required
/// for the environment package, including packages directory and
/// env package subdirectory setup.
class DirectoryManager {
  /// Ensures a directory exists, creating it if necessary
  static void ensureDirectoryExists(String dirPath, {String? description}) {
    final directory = Directory(dirPath);
    if (!directory.existsSync()) {
      if (description != null) {
        print('Creating $description...');
      }

      try {
        directory.createSync(recursive: true);
      } catch (e) {
        throw FileSystemException('Error creating directory at $dirPath: $e');
      }
    }
  }

  /// Gets or creates the packages directory
  static Directory getPackagesDirectory(String currentDir) {
    final packagesPath = p.join(currentDir, CliConfig.packagesFolderName);
    ensureDirectoryExists(packagesPath, description: 'packages directory');
    return Directory(packagesPath);
  }

  /// Gets or creates the env package directory
  static Future<Directory> getEnvPackageDirectory(
    String currentDir,
    String outputDirPath,
    env_builder_cli.EnvBuilder envBuilder,
  ) async {
    final envPackagePath = p.join(currentDir, outputDirPath);
    final envPackageDir = Directory(envPackagePath);

    if (!envPackageDir.existsSync()) {
      await _createEnvPackageForPath(envPackagePath, outputDirPath, envBuilder);
    } else {
      print('Env package already exists at ${envPackageDir.path}');
    }

    return envPackageDir;
  }

  static Future<void> _createEnvPackageForPath(
    String envPackagePath,
    String outputDirPath,
    env_builder_cli.EnvBuilder envBuilder,
  ) async {
    print('Creating env Flutter package...');

    // Get parent directory and package name
    final parentDir = p.dirname(envPackagePath);
    final packageName = p.basename(envPackagePath);

    // Ensure parent directory exists
    ensureDirectoryExists(parentDir, description: 'output directory');

    final createResult = await envBuilder.flutterCommand([
      'create',
      '--template=package',
      packageName,
    ], path: parentDir);

    if (createResult.exitCode != 0) {
      stderr.write(createResult.stderr);
      throw ProcessException(
        'flutter',
        ['create', '--template=package', packageName],
        'Failed to create Flutter package',
        createResult.exitCode,
      );
    }
  }


}
