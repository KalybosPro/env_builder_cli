import 'package:args/command_runner.dart';
import 'package:env_builder_cli/env_builder_cli.dart' as env_builder_cli;

import '../../core/core.dart';

import '../cli_config.dart';
import '../dart_file_generator.dart';
import '../directory_manager.dart';
import '../file_copier.dart';
import '../file_validator.dart';
import '../package_configurator.dart';
import 'package:path/path.dart' as p;

// ignore_for_file: avoid_print

/// Command for building env packages from .env files
class BuildCommand extends Command<int> {

  @override
  String get description => 'Build env package from .env files';

  @override
  String get name => 'build';

  BuildCommand() {
    argParser.addOption('env-file', abbr: 'e', help: 'Environment file(s) - if not specified, all .env* files will be used');
  }


  @override
  Future<int> run() async {
    try {
      final envFileArg = argResults!['env-file'] as String?;
      List<String> envFilePaths;

      if (envFileArg == null || envFileArg.isEmpty) {
        // Scan for .env* files if no specific file provided
        envFilePaths = _findEnvFilesInDirectory(Directory.current);
        if (envFilePaths.isEmpty) {
          throw ArgumentError('No .env* files found in current directory and --env-file not specified');
        }
      } else {
        // Extract environment file paths from argument
        envFilePaths = envFileArg
            .split(',')
            .where((path) => path.trim().isNotEmpty)
            .map((path) => path.trim())
            .toList();

        if (envFilePaths.isEmpty) {
          throw ArgumentError('No environment files specified');
        }

        // Validate environment files exist
        FileValidator.validateEnvFiles(envFilePaths);
      }

      final envBuilder = env_builder_cli.EnvBuilderCli();
      final dartFileGenerator = DartFileGenerator(envBuilder);
      final packageConfigurator = PackageConfigurator(envBuilder);

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

      // Run build_runner build in the env package
      await _runBuildRunner(envPackageDir.path);

      await _wantToEncryptEnvFile(envFilePaths.length);

      // Success message
      print(TextTemplates.successMessage);
      print(TextTemplates.successImport);
      print(TextTemplates.successPackage);

      return 0; // Exit success code
      } catch (e) {
        _handleError(e);
        return 64; // Exit usage code
      }
  }



  void _handleError(dynamic error) {
    if (error is ArgumentError) {
      print(TextTemplates.errorInvalidArguments.replaceAll('{message}', error.message));
      print(TextTemplates.errorUseFormat);
    } else if (error is FileSystemException) {
      print(TextTemplates.errorFileSystem.replaceAll('{message}', error.message));
    } else if (error is ProcessException) {
      print(TextTemplates.errorProcess.replaceAll('{message}', error.message));
    } else {
      print(TextTemplates.errorUnexpected.replaceAll('{message}', error.toString()));
    }
  }

  Future<void> _runBuildRunner(String envPackagePath) async {
    print('\nRunning dart run build_runner build in env package...');

    try {
      final result = await ProcessRunner.runDartCommand(
        ['run', 'build_runner', 'build'],
        envPackagePath,
      );

      if (result.exitCode == 0) {
        print('build_runner build succeeded in env package');
      } else {
        stderr.write(result.stderr);
        throw ProcessException(
          'dart',
          ['run', 'build_runner', 'build'],
          'build_runner build failed',
          result.exitCode,
        );
      }
    } catch (e) {
      print('Error running build_runner: $e');
      rethrow;
    }
  }

  Future<void> _wantToEncryptEnvFile(int envFilesLength) async {
    if (envFilesLength > 0) {
      print(TextTemplates.wantToEncryptPrompt);
      try {
        final response = stdin.readLineSync();
        final re = response != null && response.toLowerCase() == 'y';

        if (re) {
          final password = EnvCrypto.askPassword(TextTemplates.enterSecretKey);
          print(TextTemplates.encryptingFiles);
          for (final file in FileCopier.envFiles) {
            final output = '$file.encrypted';
            await EnvCrypto.encryptFile(file, output, password);
          }
          for (var path in FileCopier.envFiles) {
            File(path).deleteSync();
          }
        } else {
          print(TextTemplates.skippingEncryption);
          print(TextTemplates.rememberNoPlainEnv);
        }
      } catch (e) {
        print(TextTemplates.errorInputRead.replaceAll('{message}', e.toString()));
      }
    }
  }

  /// Finds all .env* files in the given directory
  List<String> _findEnvFilesInDirectory(Directory directory) {
    final envFiles = <String>[];
    final entities = directory.listSync(recursive: false);

    for (final entity in entities) {
      if (entity is File) {
        final fileName = p.basename(entity.path);
        if (fileName.startsWith('.env')) {
          envFiles.add(entity.path);
        }
      }
    }

    // Sort the files to have consistent ordering
    envFiles.sort();
    return envFiles;
  }

}
