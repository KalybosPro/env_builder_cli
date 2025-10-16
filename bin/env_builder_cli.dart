// ignore_for_file: avoid_print

import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:env_builder_cli/env_builder_cli.dart';
import 'package:env_builder_cli/src/bin/commands/commands.dart';


/// Application entry point
///
/// Initializes and runs the environment builder CLI application,
/// using the command runner pattern for better command organization.
Future<void> main(List<String> args) async {
  final commandRunner = CommandRunner<int>('env_builder', 'Automate Flutter env package creation')
    ..addCommand(BuildCommand())
    ..addCommand(EncryptCommand())
    ..addCommand(DecryptCommand())
    ..addCommand(VersionCommand());

  try {
    final exitCode = await commandRunner.run(args);
    exit(exitCode ?? 0);
  } catch (e) {
    print('Error: $e');
    exit(64);
  }
}
