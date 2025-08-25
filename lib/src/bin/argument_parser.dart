import 'bin.dart';

/// Handles command line argument parsing and validation
class ArgumentParser {
  final List<String> args;
  
  ArgumentParser(this.args);

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
}
