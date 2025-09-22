library;

import 'package:env_builder_cli/env_builder_cli.dart';

/// Application entry point
Future<void> main(List<String> args) async {
  final app = EnvBuilderCliApp(args);
  await app.run();
}
