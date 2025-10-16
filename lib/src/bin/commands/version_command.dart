// ignore_for_file: avoid_print

import 'package:args/command_runner.dart';
import 'package:env_builder_cli/src/core/core.dart';

/// Command to display version information
class VersionCommand extends Command<int> {
  @override
  String get description => 'Display version information';

  @override
  String get name => 'version';

  @override
  List<String> get aliases => ['--version', '-v'];

  @override
  Future<int> run() async {
    try {

      print('Env Builder CLI v${TextTemplates.cliVersion}');
      print('Built with Dart SDK ${TextTemplates.dartSdkVersion}');
      print('');
      print('Description:');
      print('A powerful Dart CLI tool that automates the generation and');
      print('management of environment-specific Flutter packages using Envied');
      print('for type-safe access to environment variables.');
      print('');
      print('Homepage: https://github.com/KalybosPro/env_builder_cli');

      return 0;
    } catch (e) {
      print('Error retrieving version: $e');
      return 1;
    }
  }
}
