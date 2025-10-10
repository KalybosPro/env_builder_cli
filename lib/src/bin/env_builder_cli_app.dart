import '../core/core.dart';
import 'bin.dart';
import 'package:path/path.dart' as p;
import 'package:env_builder_cli/env_builder_cli.dart' as env_builder_cli;

/// Main CLI application orchestrator
class EnvBuilderCliApp {
  final env_builder_cli.EnvBuilder envBuilder;
  final ArgumentParser argumentParser;
  late final DartFileGenerator dartFileGenerator;
  late final PackageConfigurator packageConfigurator;
  late final EnvFileCrypto _envFileCrypto;

  EnvBuilderCliApp(List<String> args)
    : envBuilder = env_builder_cli.EnvBuilderCli(),
      argumentParser = ArgumentParser(args) {
    _envFileCrypto = EnvFileCrypto(argumentParser);
    dartFileGenerator = DartFileGenerator(envBuilder);
    packageConfigurator = PackageConfigurator(envBuilder);
  }

  /// Main entry point for the CLI application
  Future<void> run() async {
    try {
      // To encrypt or decrypt .env file
      if (argumentParser.isCrypto()) {
        await _envFileCrypto.run();
        exit(0);
      } else {
        // Validate arguments
        if (!argumentParser.isValidArguments()) {
          envBuilder.printUsage();
          exit(1);
        }

        final envFilePaths = argumentParser.extractEnvFilePaths();

        // Validate environment files exist
        FileValidator.validateEnvFiles(envFilePaths);

        // Setup directories
        final currentDir = Directory.current.path;
        final packagesDir = DirectoryManager.getPackagesDirectory(currentDir);
        final envPackageDir = await DirectoryManager.getEnvPackageDirectory(
          packagesDir,
          envBuilder,
        );

        // Copy environment files
        await FileCopier.copyEnvFiles(envFilePaths, envPackageDir);

        // Create source directory
        final srcDirPath = p.join(
          envPackageDir.path,
          CliConfig.libFolderName,
          CliConfig.srcFolderName,
        );
        DirectoryManager.ensureDirectoryExists(srcDirPath);
        final srcDir = Directory(srcDirPath);

        // Generate Dart files
        await dartFileGenerator.generateEnvDartFiles(envFilePaths, srcDir);
        dartFileGenerator.generateEnumsFile(envFilePaths.first, srcDir);
        dartFileGenerator.generateLibraryExportFile(
          envFilePaths,
          envPackageDir,
        );
        dartFileGenerator.generateAppFlavorFile(envFilePaths, srcDir);

        // Configure package
        await packageConfigurator.configureEnvPackage(envPackageDir);
        packageConfigurator.updateRootPubspec(currentDir);
        await packageConfigurator.runPubGet();
        await _wantToEncryptEnvFile();
        // Success message
        _printSuccessMessage();
        exit(0);
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic error) {
    if (error is ArgumentError) {
      print('Error: ${error.message}');
      print('Use --env-file=<file1>,<file2>,...');
    } else if (error is FileSystemException) {
      print('File System Error: ${error.message}');
    } else if (error is ProcessException) {
      print('Process Error: ${error.message}');
    } else {
      print('Unexpected error: $error');
    }
    exit(1);
  }

  void _printSuccessMessage() {
    print('\nDone! Your env package is ready to use.');
    print("Import it in your app like:");
    print("import 'package:env/env.dart';\n");
  }

  Future<void> _wantToEncryptEnvFile() async {
    print(
      'Do you want to encrypt your .env files in your env package? (y/n): ',
    );
    try {
      final response = stdin.readLineSync();
      final re = response != null && response.toLowerCase() == 'y';

      if (re) {
        final password = EnvCrypto.askPassword('Enter the secret key: ');
        print('Encrypting .env files...');
        for (final file in FileCopier.envFiles) {
          final output = '$file.encrypted';
          await EnvCrypto.encryptFile(file, output, password);
        }
        for (var path in FileCopier.envFiles) {
          File(path).deleteSync();
        }
      } else {
        print('Skipping encryption of .env files.');
        print(
          'Remember to avoid committing plain .env files to version control!',
        );
        return;
      }
    } catch (e) {
      print('Error reading input: $e');
      return;
    }
  }
}
