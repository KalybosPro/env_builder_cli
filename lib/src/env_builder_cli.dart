// ignore_for_file: avoid_print

import 'core/core.dart';

/// Main implementation of the EnvBuilder interface
///
/// {@template env_builder_cli}
/// [EnvBuilderCli] provides a concrete implementation of [EnvBuilder] for
/// automating environment variable management in Flutter projects.
///
/// This class integrates various components to:
/// - Parse environment files (.env.*)
/// - Generate Dart classes for type-safe access
/// - Create Flutter packages with encrypted environment variables
/// - Handle encryption/decryption of sensitive data
/// - Update project configurations with dependencies
/// {@endtemplate}
class EnvBuilderCli implements EnvBuilder {
  @override
  String envDartFileSuffix(String fileName) =>
      NamingUtils.getEnvironmentSuffix(fileName);

  @override
  String capitalizeFirst(String input) => NamingUtils.capitalizeFirst(input);

  @override
  String toCamelCase(String input) => NamingUtils.toCamelCase(input);

  @override
  String fileExporter(String suffix) =>
      CodeGenerator.generateFileExporter(suffix);

  @override
  String generateEnvClassContent(
    String envFileName,
    String envClassName,
    File envFile,
  ) =>
      CodeGenerator.generateEnvClassContent(envFileName, envClassName, envFile);

  @override
  String generateEnvClassName(String envFileName) =>
      NamingUtils.getEnvironmentClassName(envFileName);

  @override
  String generateEnvDartFileName(String envFileName) =>
      NamingUtils.getEnvironmentDartFileName(envFileName);

  @override
  void updatePubspecYaml(File pubspecFile, String path) async =>
      await YamlManager.updatePubspecYaml(pubspecFile, path);

  @override
  void updateRootPubspecWithEnvPackage(String rootPubspecPath) =>
      YamlManager.updateRootPubspecWithEnvPackage(rootPubspecPath);

  @override
  Map<String, String> parseEnvFile(File file) =>
      EnvFileParser.parseEnvFile(file);

  @override
  Future<void> createGitignoreWithEnvEntries({
    String path = '.gitignore',
    bool includeFlutterDefaults = true,
    bool keepExample = true,
  }) async => await FileSystemManager.createGitignoreWithEnvEntries(
    path: path,
    includeFlutterDefaults: includeFlutterDefaults,
    keepExample: keepExample,
  );

  @override
  Future<ProcessResult> flutterCommand(
    List<String> arguments, {
    String? path,
    String engine = 'flutter',
  }) async => await ProcessRunner.runFlutterCommand(
    arguments,
    path: path,
    engine: engine,
  );

  @override
  String generateEnumClassContent(File file) =>
      CodeGenerator.generateEnumClassContent(file);

  @override
  String generateAppFlavorContent(List<String> paths) =>
      CodeGenerator.generateAppFlavorContent(paths);

  @override
  String getFlavor(String fileName) => NamingUtils.getFlavor(fileName);

  @override
  void writeEnvTestFile(String path) =>
      FileSystemManager.writeEnvTestFile(path);

  @override
  void printUsage() {
    print('''
Usage:
  env_builder --env-file=.env.development,.env.production,.env.staging

Description:
  Automates creation or update of the env Flutter package inside packages/env 
  by copying specified .env files, generating Dart code with Envied, 
  updating dependencies, and running flutter pub get automatically.
''');
  }
}
