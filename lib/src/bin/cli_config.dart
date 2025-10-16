// ignore_for_file: avoid_print

/// Configuration constants for the CLI application
///
/// Defines fixed configuration values used throughout the CLI tool,
/// including package names, folder structures, and command prefixes.
/// These constants centralize configuration for maintainability.
class CliConfig {
  static const String envPackageName = 'env';
  static const String packagesFolderName = 'packages';
  static const String libFolderName = 'lib';
  static const String srcFolderName = 'src';
  static const String configFolderName = 'config';
  static const String testFolderName = 'test';
  static const String envFilePrefix = '--env-file=';
  static const String envFileArg = 'env-file';
}
