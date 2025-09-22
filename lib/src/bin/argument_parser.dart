import 'bin.dart';
import 'package:args/args.dart';

/// Handles command line argument parsing and validation
class ArgumentParser {
  final List<String> args;

  ArgumentParser(this.args);

  bool isCrypto() =>
      args.isNotEmpty && (args.toString().contains('encrypt') ||
      args.toString().contains('decrypt'));

  /// Validates command line arguments
  bool isValidArguments() {
    return args.isNotEmpty &&
        args.length == 1 &&
        args.first.startsWith(CliConfig.envFilePrefix);
  }

  /// Extracts environment file paths from arguments
  List<String> extractEnvFilePaths() {
    if (!isValidArguments()) {
      throw ArgumentError('Invalid arguments provided');
    }

    final envFilesArg = args.first;
    final envFilePaths = envFilesArg
        .substring(CliConfig.envFilePrefix.length)
        .split(',')
        .where((path) => path.trim().isNotEmpty)
        .map((path) => path.trim())
        .toList();

    if (envFilePaths.isEmpty) {
      throw ArgumentError('No environment files specified');
    }

    return envFilePaths;
  }

  ArgResults cryptoCommand() {
    final encryptCmd = ArgParser()
      ..addOption('password', abbr: 'p', help: 'Secret key');
    final decryptCmd = ArgParser()
      ..addOption('password', abbr: 'p', help: 'Secret key');

    final parser = ArgParser()
      ..addCommand('encrypt', encryptCmd)
      ..addCommand('decrypt', decryptCmd);

    final results = parser.parse(args);

    return results;
  }
}
