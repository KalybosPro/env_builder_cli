// ignore_for_file: avoid_print

import 'core.dart';

/// Handles process execution
///
/// Provides utilities for running external commands, particularly
/// Flutter and Dart commands, with proper error handling and
/// working directory support.
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
