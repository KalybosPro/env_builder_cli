// ignore_for_file: avoid_print

import 'core.dart';
import 'package:path/path.dart' as p;

/// Handles file system operations
///
/// Manages file system interactions including:
/// - Creating and updating .gitignore files with environment rules
/// - Writing test files for environment packages
/// - Handling temporary file operations and validation
class FileSystemManager {
  /// Creates or updates .gitignore file with environment rules
  static Future<void> createGitignoreWithEnvEntries({
    String path = '.gitignore',
    bool includeFlutterDefaults = true,
    bool keepExample = true,
  }) async {
    final file = File(path);
    final exists = file.existsSync();

    final content = _buildGitignoreContent(includeFlutterDefaults, keepExample);

    if (exists) {
      await _updateExistingGitignore(file, content);
    } else {
      await file.writeAsString(content);
      print('Created .gitignore with Dart/Flutter and .env rules.');
    }
  }

  static String _buildGitignoreContent(
    bool includeFlutterDefaults,
    bool keepExample,
  ) {
    final flutterIgnore = '''
# Dart & Flutter
.dart_tool/
.packages
.pub-cache/
build/
coverage/

# VS Code
.vscode/

# IntelliJ / Android Studio
*.iml
.idea/
*.iws
*.ipr
*.bak

# Logs and locks
*.log
*.lock
pubspec.lock
''';

    final envIgnore =
        '''
# Env files (do not commit secrets)
.env
.env.*
${keepExample ? '!.env.example' : ''}
''';

    final content = StringBuffer();
    if (includeFlutterDefaults) {
      content.writeln(flutterIgnore.trim());
      content.writeln();
    }
    content.writeln(envIgnore.trim());

    return content.toString();
  }

  static Future<void> _updateExistingGitignore(
    File file,
    String content,
  ) async {
    final existingContent = await file.readAsString();
    if (!existingContent.contains('.env')) {
      await file.writeAsString('\n$content', mode: FileMode.append);
      print('Appended .env rules to existing .gitignore');
    } else {
      print('.gitignore already contains .env rules.');
    }
  }

  /// Writes environment test file
  static void writeEnvTestFile(String path) {
    final testDir = Directory(p.join(path, 'test'));
    final testFile = File(p.join(testDir.path, '${TextTemplates.packageName}_test.dart'));

    try {
      if (!testDir.existsSync()) {
        testDir.createSync(recursive: true);
      }

      testFile.writeAsStringSync(CodeGenerator.generateTestFileContent());
      print('env_test.dart file created/updated at ${testFile.path}');
    } catch (e) {
      print('Error writing env_test.dart file: $e');
      exit(1);
    }
  }
}
