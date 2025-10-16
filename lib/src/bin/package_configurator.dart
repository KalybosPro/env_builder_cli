// ignore_for_file: avoid_print

import '../core/core.dart';
import 'package:path/path.dart' as p;
import 'package:env_builder_cli/env_builder_cli.dart' as env_builder_cli;

/// Handles package configuration and dependency management
///
/// Configures the generated environment package by setting up
/// pubspec.yaml, creating .gitignore, writing test files, and
/// managing root project dependencies to properly integrate
/// the env package.
class PackageConfigurator {
  final env_builder_cli.EnvBuilder envBuilder;

  PackageConfigurator(this.envBuilder);

  /// Configures the env package (pubspec.yaml, test files, gitignore)
  Future<void> configureEnvPackage(Directory envPackageDir) async {
    await _updatePubspecYaml(envPackageDir);
    await _createGitignore(envPackageDir);
    _writeTestFile(envPackageDir);
  }

  Future<void> _updatePubspecYaml(Directory envPackageDir) async {
    final pubspecFilePath = p.join(envPackageDir.path, 'pubspec.yaml');
    final pubspecFile = File(pubspecFilePath);

    try {
      envBuilder.updatePubspecYaml(pubspecFile, envPackageDir.path);
    } catch (e) {
      throw FileSystemException('Error updating env package pubspec.yaml: $e');
    }
  }

  Future<void> _createGitignore(Directory envPackageDir) async {
    final gitIgnorePath = p.join(envPackageDir.path, '.gitignore');

    try {
      await envBuilder.createGitignoreWithEnvEntries(path: gitIgnorePath);
    } catch (e) {
      throw FileSystemException('Error creating .gitignore: $e');
    }
  }

  void _writeTestFile(Directory envPackageDir) {
    try {
      envBuilder.writeEnvTestFile(envPackageDir.path);
    } catch (e) {
      throw FileSystemException('Error writing test file: $e');
    }
  }

  /// Updates the root project's pubspec.yaml to include the env package
  void updateRootPubspec(String currentDir) {
    final rootPubspecPath = p.join(currentDir, 'pubspec.yaml');

    try {
      envBuilder.updateRootPubspecWithEnvPackage(rootPubspecPath);
    } catch (e) {
      throw FileSystemException('Error updating root project pubspec.yaml: $e');
    }
  }

  /// Runs flutter pub get in the root project
  Future<void> runPubGet() async {
    print('\nRunning flutter pub get in root project...');

    final pubGetResult = await envBuilder.flutterCommand(['pub', 'get']);

    if (pubGetResult.exitCode == 0) {
      print('flutter pub get succeeded in root project');
    } else {
      stderr.write(pubGetResult.stderr);
      throw ProcessException(
        'flutter',
        ['pub', 'get'],
        'flutter pub get failed',
        pubGetResult.exitCode,
      );
    }
  }
}
