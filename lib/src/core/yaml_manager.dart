// ignore_for_file: avoid_print

import 'core.dart';

/// Handles YAML file operations
///
/// Manages pubspec.yaml files for both the env package and root Flutter project,
/// ensuring proper dependency management and configuration updates.
class YamlManager {
  /// Updates pubspec.yaml with required dependencies
  static Future<void> updatePubspecYaml(File pubspecFile, String path) async {
    if (pubspecFile.existsSync()) {
      await _updateExistingPubspec(pubspecFile, path);
    } else {
      await _createNewPubspec(pubspecFile, path);
    }
  }

  static Future<void> _updateExistingPubspec(
    File pubspecFile,
    String path,
  ) async {
    final content = pubspecFile.readAsStringSync();
    final doc = loadYaml(content);
    final editor = YamlEditor(content);

    try {
      // Update description and version
      _updateYamlField(
        editor,
        doc,
        'description',
        EnvConfig.defaultDescription,
      );
      _updateYamlField(editor, doc, 'version', EnvConfig.defaultVersion);

      pubspecFile.writeAsStringSync(editor.toString());
      print(TextTemplates.pubspecUpdated);
    } catch (e) {
      print(
        TextTemplates.pubspecUpdateFailed.replaceAll('{error}', e.toString()),
      );
    }

    await _addDependencies(pubspecFile, path);
  }

  static Future<void> _createNewPubspec(File pubspecFile, String path) async {
    await _addDependencies(pubspecFile, path);
    print(TextTemplates.pubspecCreated);
  }

  static void _updateYamlField(
    YamlEditor editor,
    dynamic doc,
    String field,
    String value,
  ) {
    if (doc is YamlMap && !doc.containsKey(field)) {
      editor.update([field], value);
    } else {
      editor.update([field], value);
    }
  }

  static Future<void> _addDependencies(File pubspecFile, String path) async {
    final content =
        '''
name: ${TextTemplates.packageName}
description: ${EnvConfig.defaultDescription}
version: ${EnvConfig.defaultVersion}
publish_to: none

environment:
  sdk: ${EnvConfig.defaultSdkVersion}
  flutter: "${EnvConfig.defaultFlutterVersion}"

dependencies:
  envied: ^1.3.1

dev_dependencies:
  build_runner: ^2.10.3
  envied_generator: ^1.3.1
  flutter_test:
    sdk: flutter


  flutter_lints: ^5.0.0


flutter:
  uses-material-design: true
''';
    pubspecFile.writeAsStringSync(content);

    await ProcessRunner.runDartCommand(['run', 'build_runner', 'build'], path);
  }

  /// Updates root pubspec.yaml with env package dependency
  static void updateRootPubspecWithEnvPackage(String rootPubspecPath) {
    final file = File(rootPubspecPath);
    if (!file.existsSync()) {
      print(
        TextTemplates.pubspecRootNotFound.replaceAll('{path}', rootPubspecPath),
      );
      exit(1);
    }

    final originalYaml = file.readAsStringSync();
    final doc = loadYaml(originalYaml);
    final editor = YamlEditor(originalYaml);

    final Map? dependencies = (doc as Map?)?['dependencies'] as Map?;

    if (dependencies == null) {
      editor.update(
        ['dependencies'],
        {
          TextTemplates.packageName: {
            'path': 'packages/${TextTemplates.packageName}',
          },
        },
      );
      file.writeAsStringSync(editor.toString());
      print(TextTemplates.pubspecDependencyAdded);
      return;
    }

    if (!dependencies.containsKey(TextTemplates.packageName)) {
      editor.update(
        ['dependencies', TextTemplates.packageName],
        {'path': 'packages/${TextTemplates.packageName}'},
      );
      file.writeAsStringSync(editor.toString());
      print(TextTemplates.pubspecDependencyUpdated);
    } else {
      print(TextTemplates.pubspecDependencyExists);
    }
  }
}
