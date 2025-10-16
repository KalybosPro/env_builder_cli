
// ignore_for_file: avoid_print

import 'package:env_builder_cli/src/core/core.dart';
import 'package:env_builder_cli/src/env_builder_cli.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

/// Test suite for the EnvBuilderCli and its core functionality
///
/// Tests the main features of the env_builder_cli package including:
/// - Environment class name generation
/// - Dart file naming conventions
/// - Environment suffix extraction
/// - String manipulation utilities
/// - File parsing capabilities
void main() {
  late EnvBuilder builder;

  setUp(() {
    builder = EnvBuilderCli();
  });

  group('EnvBuilder', () {
    test('generateEnvClassName should convert file name to class name', () {
      expect(
        builder.generateEnvClassName('.env.development'),
        equals('EnvDev'),
      );
      expect(
        builder.generateEnvClassName('.env.production'),
        equals('EnvProd'),
      );
    });

    test('generateEnvDartFileName should return correct Dart filename', () {
      expect(
        builder.generateEnvDartFileName('.env.development'),
        equals('env.dev.dart'),
      );
    });

    test('envDartFileSuffix returns suffix correctly', () {
      expect(builder.envDartFileSuffix('.env.development'), equals('dev'));
      expect(builder.envDartFileSuffix('.env.production'), equals('prod'));
    });

    test('toCamelCase converts SCREAMING_SNAKE_CASE to camelCase', () {
      expect(builder.toCamelCase('API_KEY'), equals('apiKey'));
      expect(
        builder.toCamelCase('SUPABASE_ANON_KEY'),
        equals('supabaseAnonKey'),
      );
    });

    test('capitalizeFirst works correctly', () {
      expect(builder.capitalizeFirst('hello'), equals('Hello'));
      expect(builder.capitalizeFirst('WORLD'), equals('World'));
    });

    test('getFlavor returns the correct flavor name', () {
      expect(builder.getFlavor('.env.development'), equals('development'));
      expect(builder.getFlavor('.env.production'), equals('production'));
      expect(builder.getFlavor('.env.staging'), equals('staging'));
    });

    test('parseEnvFile parses .env file correctly', () async {
      final tempFile = File(p.join(Directory.systemTemp.path, 'test.env'));
      await tempFile.writeAsString('''
# Comment
API_KEY=abc123
BASE_URL="https://example.com"
QUOTED='with spaces'
      ''');

      final parsed = builder.parseEnvFile(tempFile);

      expect(parsed['API_KEY'], equals('abc123'));
      expect(parsed['BASE_URL'], equals('https://example.com'));
      expect(parsed['QUOTED'], equals('with spaces'));

      tempFile.deleteSync();
    });
  });
}
