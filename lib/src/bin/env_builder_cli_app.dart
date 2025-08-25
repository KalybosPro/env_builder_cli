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

  EnvBuilderCliApp(List<String> args)
      : envBuilder = env_builder_cli.EnvBuilderCli(),
        argumentParser = ArgumentParser(args) {
    dartFileGenerator = DartFileGenerator(envBuilder);
    packageConfigurator = PackageConfigurator(envBuilder);
  }

  /// Main entry point for the CLI application
  Future<void> run() async {
    try {
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
      dartFileGenerator.generateLibraryExportFile(envFilePaths, envPackageDir);
      dartFileGenerator.generateAppFlavorFile(envFilePaths, srcDir);

      // Configure package
      await packageConfigurator.configureEnvPackage(envPackageDir);
      packageConfigurator.updateRootPubspec(currentDir);
      await packageConfigurator.runPubGet();

      // Success message
      _printSuccessMessage();

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
}
