import 'core.dart';

/// Handles process execution
class ProcessRunner {
  /// Runs a flutter/dart command
  static Future<ProcessResult> runFlutterCommand(
    List<String> arguments, {
    String? path,
    String engine = 'flutter',
  }) async {
    return await Process.run(
      engine,
      arguments,
      workingDirectory: path,
      runInShell: true,
    );
  }

  /// Runs a dart command specifically
  static Future<ProcessResult> runDartCommand(
    List<String> arguments,
    String? path,
  ) async {
    return await runFlutterCommand(arguments, path: path, engine: 'dart');
  }
}
