/// Centralized text templates for CLI messages
///
/// This class contains all text messages used throughout the application
/// to facilitate internationalization and consistency.
class TextTemplates {
  /// Hold the package name
  static String packageName = '';

  // Usage messages
  static const String usage = '''
Usage:
  env_builder build                     # Uses all .env* files in current directory
  env_builder build --env-file=<file1>,<file2>,...  # Specify specific files

Examples:
  env_builder build                     # Auto-detects .env.ci, .env.custom, .env.app, etc.
  env_builder build --env-file=.env.staging
  env_builder build --env-file=.env.dev,.env.prod

Crypto operations:
  env_builder encrypt --password=<secret> --env-file=<file>
  env_builder decrypt --password=<secret> --env-file=<file>
''';

  static const String help = 'Available Commands: encrypt | decrypt';

  // Success messages
  static const String successMessage =
      '\nDone! Your env package is ready to use.';
  static const String successImport = "Import it in your app like:";
  static const String successPackage = "import 'package:env/env.dart';\n";

  // Error messages
  static const String errorInvalidArguments = 'Error: {message}';
  static const String errorUseFormat = 'Use --env-file=<file1>,<file2>,...';
  static const String errorFileSystem = 'File System Error: {message}';
  static const String errorProcess = 'Process Error: {message}';
  static const String errorUnexpected = 'Unexpected error: {message}';
  static const String errorInputRead = 'Error reading input: {message}';

  // File operations
  static const String fileCopied = 'Copied {fileName} file to {path}';
  static const String fileGenerated = 'Generated {filePath}';
  static const String fileEncrypted =
      'File successfully encrypted to: {outputPath}';
  static const String fileDecrypted =
      'File successfully decrypted to: {outputPath}';
  static const String fileNotExists =
      'Error: File "{inputPath}" does not exist.';
  static const String fileEmptyEncrypt =
      'Warning: File "{inputPath}" is empty, nothing to encrypt.';
  static const String fileEmptyDecrypt =
      'Warning: File "{inputPath}" is empty, nothing to decrypt.';
  static const String fileSystemError =
      'File system error: {message} (path: {path})';
  static const String encodingError = 'Encoding error: {message}';
  static const String invalidArgument = 'Invalid argument: {message}';
  static const String cryptoInvalidPassword =
      'Error: Invalid password or corrupted file.';
  static const String cryptoNotValidBase64 =
      'Error: File content is not valid Base64.';

  // Directory operations
  static const String creatingDirectory = 'Creating {description}...';
  static const String directoryExists = 'Env package already exists at {path}';
  static const String creatingPackage = 'Creating env Flutter package...';

  // Package operations
  static const String pubGetRunning =
      '\nRunning flutter pub get in root project...';
  static const String pubGetSuccess =
      'flutter pub get succeeded in root project';

  // YAML operations
  static const String pubspecUpdated =
      'pubspec.yaml updated with new description.';
  static const String pubspecUpdateFailed =
      'Failed to update pubspec.yaml: {error}';
  static const String pubspecCreated =
      'Created pubspec.yaml with envied dependencies and flutter plugin platforms.';
  static const String pubspecRootNotFound =
      'Error: root pubspec.yaml not found at {path}!';
  static const String pubspecDependencyAdded =
      'Added env package as a path dependency to root pubspec.yaml (dependencies section added).';
  static const String pubspecDependencyUpdated =
      'Added env package as a path dependency to root pubspec.yaml.';
  static const String pubspecDependencyExists =
      'env package dependency already exists in root pubspec.yaml.';

  // Git operations
  static const String gitignoreCreated =
      'Created .gitignore with Dart/Flutter and .env rules.';
  static const String gitignoreAppended =
      'Appended .env rules to existing .gitignore';
  static const String gitignoreEnvExists =
      '.gitignore already contains .env rules.';
  static const String testFileCreated =
      'env_test.dart file created/updated at {path}';
  static const String testFileError =
      'Error writing env_test.dart file: {error}';

  // Crypto operations
  static const String enterSecretKey = 'Enter the secret key: ';
  static const String encryptingFiles = 'Encrypting .env files...';
  static const String skippingEncryption = 'Skipping encryption of .env files.';
  static const String rememberNoPlainEnv =
      'Remember to avoid committing plain .env files to version control!';
  static const String removeFiles =
      'Consider removing plain .env files before deployment for security.';

  // User prompts
  static const String wantToEncryptPrompt =
      'Do you want to encrypt your .env files in your env package? (y/n): ';

  // CLI version
  static const String cliVersion = '1.1.2';
  // Dart SDK version from prerequisites
  static const String dartSdkVersion = '3.8.1+';
}
