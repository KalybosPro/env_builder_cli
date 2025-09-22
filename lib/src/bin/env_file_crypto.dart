import 'package:env_builder_cli/src/bin/bin.dart' show ArgumentParser;
import 'package:env_builder_cli/src/core/core.dart' show EnvCrypto;

class EnvFileCrypto {
  EnvFileCrypto(this.arg);

  final ArgumentParser arg;
  Future<void> run() async {
    final result = arg.cryptoCommand();
    if (result.command == null) {
      print("Available Commands: encrypt | decrypt");
      return;
    }

    final cmd = result.command!;

    if (cmd.name == 'encrypt') {
      await encrypt();
    } else if (cmd.name == 'decrypt') {
      await decrypt();
    }
    return;
  }

  Future<void> encrypt() async {
    final result = arg.cryptoCommand();
    final cmd = result.command!;
    final args = cmd.rest;
    final password =
        cmd['password'] ?? EnvCrypto.askPassword('Enter the secret key');

    final output = _isEmptyOrNull(args[1]) ? '.env.encrypted' : args[1];

    await EnvCrypto.encryptFile(args[0], output, password);
  }

  Future<void> decrypt() async {
    final result = arg.cryptoCommand();
    final cmd = result.command!;
    final args = cmd.rest;
    final password =
        cmd['password'] ?? EnvCrypto.askPassword('Enter the secret key');

    final output = _isEmptyOrNull(args[1]) ? '.env.test' : args[1];

    await EnvCrypto.decryptFile(args[0], output, password);
  }

  bool _isEmptyOrNull(String? path) => path == null || path.isEmpty;
}
