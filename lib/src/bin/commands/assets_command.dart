import 'package:args/command_runner.dart';

import '../../core/core.dart';

// ignore_for_file: avoid_print

/// Command for generating encrypted assets
class AssetsCommand extends Command<int> {
  @override
  String get description => 'Generate encrypted assets from assets/ directory';

  @override
  String get name => 'assets';

  AssetsCommand() {
    argParser.addOption(
      'encrypt',
      abbr: 'e',
      help: 'Encryption method: xor or aes',
      allowed: ['xor', 'aes'],
      defaultsTo: 'xor',
    );
    argParser.addFlag(
      'compress',
      help: 'Compress images and minify SVGs',
      defaultsTo: true,
    );
    argParser.addFlag(
      'no-compress',
      help: 'Disable compression',
      negatable: false,
    );
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Show detailed output during asset generation',
    );
  }

  @override
  Future<int> run() async {
    try {
      final encryptMethod = argResults!['encrypt'] as String;
      final compress =
          argResults!['compress'] as bool &&
          !argResults!.wasParsed('no-compress');
      final verbose = argResults!['verbose'] as bool;

      if (verbose) {
        print('🔐 Starting asset encryption and generation...');
        print('Encryption method: $encryptMethod');
        print('Compression enabled: $compress');
      }

      // Check if we're in a Flutter project
      if (!await _isFlutterProject()) {
        print('❌ Error: Not in a Flutter project directory');
        print(
          'Please run this command from the root of a Flutter project that contains an assets/ directory.',
        );
        return 1;
      }

      // Check if assets directory exists
      final assetsDir = 'assets';
      if (!await Directory(assetsDir).exists()) {
        print('❌ Error: assets/ directory not found');
        print(
          'Please create an assets/ directory with your image, video, and SVG files.',
        );
        return 1;
      }

      // Run build_runner with asset generation
      final success = await _runAssetGeneration(
        encryptMethod,
        compress,
        verbose,
      );

      if (success) {
        print('✅ Asset generation completed successfully!');
        print('');
        print('Generated package: packages/app_assets');
        print('Files generated:');
        print(
          '  - packages/app_assets/lib/assets.g.dart (encrypted asset data)',
        );
        print(
          '  - packages/app_assets/lib/assets.gen.dart (flutter_gen style API)',
        );
        print('');
        print('Usage in your app:');
        print('  import \'package:app_assets/assets.gen.dart\';');
        print('  ');
        return 0;
      } else {
        print('❌ Asset generation failed');
        return 1;
      }
    } catch (e) {
      print('❌ Error: $e');
      return 1;
    }
  }

  Future<bool> _isFlutterProject() async {
    final pubspecFile = File('pubspec.yaml');
    if (!await pubspecFile.exists()) return false;

    final content = await pubspecFile.readAsString();
    return content.contains('flutter:');
  }

  Future<bool> _runAssetGeneration(
    String encryptMethod,
    bool compress,
    bool verbose,
  ) async {
    try {
      // Create app_assets package
      await _createAppAssetsPackage(verbose);

      // Change to app_assets package directory
      final appAssetsPath = 'packages/app_assets';
      if (!await Directory(appAssetsPath).exists()) {
        print('❌ Error: Failed to create app_assets package');
        return false;
      }

      // Generate asset files directly
      final generationResult = await _generateAssetFiles(
        encryptMethod,
        compress,
        verbose,
      );

      if (generationResult) {
        // Update main pubspec.yaml to depend on app_assets
        await _addAppAssetsDependency(verbose);

        if (verbose) {
          print('✅ Asset generation completed successfully');
          print('');
          print('Generated package: packages/app_assets');
          print('Files generated:');
          print(
            '  - packages/app_assets/lib/assets.g.dart (encrypted asset data)',
          );
          print(
            '  - packages/app_assets/lib/assets.gen.dart (flutter_gen style API)',
          );
          print('');
          print('Usage in your app:');
          print('  import \'package:app_assets/assets.gen.dart\';');
          print('  ');
        }
        return true;
      } else {
        print('❌ Asset generation failed');
        return false;
      }
    } catch (e) {
      print('Error running asset generation: $e');
      return false;
    }
  }

  Future<void> _createAppAssetsPackage(bool verbose) async {
    final packagesDir = Directory('packages');
    if (!await packagesDir.exists()) {
      await packagesDir.create();
    }

    final appAssetsDir = Directory('packages/app_assets');
    if (await appAssetsDir.exists()) {
      if (verbose) {
        print('📁 app_assets package already exists, updating...');
      }
    } else {
      await appAssetsDir.create();
      if (verbose) {
        print('📁 Created app_assets package directory');
      }
    }

    // Create pubspec.yaml for app_assets package
    final pubspecContent = '''
name: app_assets
description: Encrypted assets package generated by env_builder
version: 1.0.0
publish_to: none

environment:
  sdk: ^3.0.0

dependencies:
  flutter:
    sdk: flutter
  flutter_svg: ^2.2.3
  encrypt: ^5.0.3
  image: ^4.5.4
  vector_graphics: ^1.1.19
  flutter_svg_provider: ^1.0.7

dev_dependencies:

flutter:
''';

    final pubspecFile = File('packages/app_assets/pubspec.yaml');
    await pubspecFile.writeAsString(pubspecContent);

    // Create lib directory
    final libDir = Directory('packages/app_assets/lib');
    if (!await libDir.exists()) {
      await libDir.create();
    }

    // Create assets directory and copy assets
    final assetsDir = Directory('packages/app_assets/assets');
    if (!await assetsDir.exists()) {
      await assetsDir.create(recursive: true);
    }

    // Copy assets from main project
    final sourceAssetsDir = Directory('assets');
    if (await sourceAssetsDir.exists()) {
      await _copyDirectory(sourceAssetsDir, assetsDir);
      if (verbose) {
        print('📋 Copied assets to app_assets package');
      }
    }

    // Create lib/app_assets.dart trigger file
    final triggerFile = File('packages/app_assets/lib/app_assets.dart');
    final exportedFiles = '''
/// Assets package built with env_builder
export 'assets.gen.dart';
''';
    await triggerFile.writeAsString(exportedFiles);

    if (verbose) {
      print('📦 Created app_assets package structure');
    }
  }

  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await for (final entity in source.list(recursive: true)) {
      if (entity is File) {
        final relativePath = entity.path.replaceFirst(source.path, '');
        final destFile = File('${destination.path}$relativePath');
        await destFile.create(recursive: true);
        await entity.copy(destFile.path);
      }
    }
  }

  Future<bool> _addAppAssetsDependency(bool verbose) async {
    final pubspecFile = File('pubspec.yaml');
    if (!await pubspecFile.exists()) return false;

    var content = await pubspecFile.readAsString();

    // Check if app_assets dependency already exists
    if (content.contains('app_assets:')) {
      return true; // Already present
    }

    // Add app_assets dependency
    if (content.contains('dependencies:')) {
      // Insert after existing dependencies
      final depsIndex = content.indexOf('dependencies:');
      final nextNewlineIndex = content.indexOf('\n', depsIndex);
      if (nextNewlineIndex != -1) {
        final insertPos = nextNewlineIndex + 1;
        final before = content.substring(0, insertPos);
        final after = content.substring(insertPos);
        content = '$before  app_assets:\n    path: packages/app_assets\n$after';
      }
    } else {
      // Add dependencies section
      final flutterIndex = content.indexOf('flutter:');
      if (flutterIndex != -1) {
        final beforeFlutter = content.substring(0, flutterIndex);
        final afterFlutter = content.substring(flutterIndex);
        content =
            '$beforeFlutter\ndependencies:\n  app_assets:\n    path: packages/app_assets\n\n$afterFlutter';
      }
    }

    await pubspecFile.writeAsString(content);

    // Run flutter pub get
    if (verbose) {
      print('📦 Adding app_assets dependency to main project...');
    }
    final pubGetResult = await ProcessRunner.runDartCommand([
      'pub',
      'get',
    ], null);
    if (pubGetResult.exitCode != 0) {
      stderr.write(pubGetResult.stderr);
      print(
        '⚠️ Warning: Failed to add app_assets dependency. You may need to run "flutter pub get" manually.',
      );
    }

    return pubGetResult.exitCode == 0;
  }

  Future<bool> _generateAssetFiles(
    String encryptMethod,
    bool compress,
    bool verbose,
  ) async {
    try {
      final encryptionMethod = encryptMethod == 'aes'
          ? EncryptionMethod.aes
          : EncryptionMethod.xor;

      // Generate assets.g.dart
      final assetsGenerator = AssetsGenerator(
        compress: compress,
        svgMinify: true,
        encryptionMethod: encryptionMethod,
        chunkSize: 1024,
      );

      final assetsGContent = await assetsGenerator.generate();
      if (assetsGContent.isNotEmpty) {
        final assetsGFile = File('packages/app_assets/lib/assets.g.dart');
        await assetsGFile.writeAsString(assetsGContent);
        if (verbose) {
          print('📝 Generated assets.g.dart');
        }
      }

      // Generate assets.gen.dart
      final assetsGenGenerator = AssetsGenGenerator();
      final assetsGenContent = await assetsGenGenerator.generate();
      if (assetsGenContent.isNotEmpty) {
        final assetsGenFile = File('packages/app_assets/lib/assets.gen.dart');
        await assetsGenFile.writeAsString(assetsGenContent);
        if (verbose) {
          print('📝 Generated assets.gen.dart');
        }
      }

      return true;
    } catch (e) {
      print('Error generating asset files: $e');
      return false;
    }
  }
}
