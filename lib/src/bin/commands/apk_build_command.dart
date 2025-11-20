import 'package:args/command_runner.dart';
import 'package:env_builder_cli/src/core/core.dart';

/// Subcommand for building Flutter APK
class ApkBuildCommand extends Command<int> {
  @override
  String get name => 'apk';

  @override
  String get description => 'Build Flutter APK with release obfuscation';

  ApkBuildCommand() {
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
      print('Building APK with Env Builder CLI.\n');

      final process = await ProcessRunner.runFlutterCommandStreaming([
        'build',
        'apk',
        '--release',
        '--obfuscate',
        '--split-debug-info=build/app/outputs/symbols',
        '--target=$target',
      ]);

      final exitCode = await process.exitCode;

      // Ensure cursor is visible at the end
      stdout.write('\x1b[?25h');

      if (exitCode == 0) {
        print('\nAPK build succeeded');
      }
      return exitCode;
    } catch (e) {
      print('Error building APK: $e');
      return 1;
    }
  }
}
