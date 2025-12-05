import 'package:args/command_runner.dart';
import 'package:env_builder_cli/src/core/core.dart';

/// Command for building Flutter AAB
class AabBuildCommand extends Command<int> {
  @override
  String get name => 'aab';

  @override
  String get description => 'Build Flutter AAB with release obfuscation';

  AabBuildCommand() {
    argParser.addOption(
      'target',
      abbr: 't',
      help: 'Target main Dart file path',
      defaultsTo: 'lib/main.dart',
    );
  }

  @override
  Future<int> run() async {
    try {
      final target = argResults!['target'] as String;
      print('Building AAB with Env Builder CLI.\n');

      final process = await ProcessRunner.runFlutterCommandStreaming([
        'build',
        'appbundle',
        '--release',
        '--obfuscate',
        '--split-debug-info=build/app/outputs/symbols',
        '--target=$target',
      ]);

      final exitCode = await process.exitCode;

      // Ensure cursor is visible at the end
      stdout.write('\x1b[?25h');

      if (exitCode == 0) {
        print('\nAAB build succeeded');
      }
      return exitCode;
    } catch (e) {
      print('Error building AAB: $e');
      return 1;
    }
  }
}
