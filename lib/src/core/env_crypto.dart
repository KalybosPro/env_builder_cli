// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:universal_io/io.dart';

/// Handles encryption and decryption of environment files
///
/// Provides secure encryption/decryption using AES-256 algorithm
/// with SHA-256 derived keys from user passwords.
/// Supports both interactive password input and command-line options.
class EnvCrypto {
  /// Generate AES-256 key from a password with salt
  static encrypt.Key _deriveKey(String password, {String salt = 'envied_salt'}) {
    final combined = password + salt; // Add salt for better security
    final keyHash = sha256.convert(utf8.encode(combined)).bytes;
    return encrypt.Key(Uint8List.fromList(keyHash));
  }

  /// Encrypt .env file
  static Future<void> encryptFile(
    String inputPath,
    String outputPath,
    String password,
  ) async {
    try {
      final inputFile = File(inputPath);

      if (!await inputFile.exists()) {
        print('Error: File "$inputPath" does not exist.');
        return;
      }

      final plainText = await inputFile.readAsString();
      if (plainText.trim().isEmpty) {
        print('Warning: File "$inputPath" is empty, nothing to encrypt.');
        return;
      }

      final key = _deriveKey(password);
      final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // Encrypting
      final encrypted = encrypter.encrypt(plainText, iv: iv);

      final data = {'data': encrypted.base64, 'iv': iv.base64};

      // Writing
      final outputFile = File(outputPath);
      await outputFile.writeAsString(json.encode(data));

      print('File successfully encrypted to: $outputPath');
    } on FileSystemException catch (e) {
      print('File system error: ${e.message} (path: ${e.path})');
    } on FormatException catch (e) {
      print('Encoding error: ${e.message}');
    } on ArgumentError catch (e) {
      print('Invalid argument: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  /// Decrypt .env file
  static Future<void> decryptFile(
    String inputPath,
    String outputPath,
    String password,
  ) async {
    try {
      final inputFile = File(inputPath);

      // Check if input file exists
      if (!await inputFile.exists()) {
        print('Error: File "$inputPath" does not exist.');
        return;
      }

      // Read encrypted content
      final encryptedText = await inputFile.readAsString();
      if (encryptedText.trim().isEmpty) {
        print('Warning: File "$inputPath" is empty, nothing to decrypt.');
        return;
      }

      // Derive AES key + IV
      // Currently uses a fixed IV; replace with random IV stored in the file for production
      final key = _deriveKey(password);
      // final iv = encrypt.IV.fromLength(16);
      final decoded = json.decode(encryptedText);
      final encoded = decoded['data'];
      final iv = encrypt.IV.fromBase64(decoded['iv']);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // Try to decrypt content
      String decrypted;
      try {
        decrypted = encrypter.decrypt64(encoded, iv: iv);
      } on ArgumentError catch (_) {
        print('Error: Invalid password or corrupted file.');
        return;
      } on FormatException catch (_) {
        print('Error: File content is not valid Base64.');
        return;
      }

      // Write decrypted content to output file
      final outputFile = File(outputPath);
      await outputFile.writeAsString(decrypted);

      print('File successfully decrypted to: $outputPath');
    } on FileSystemException catch (e) {
      print('File system error: ${e.message} (path: ${e.path})');
    } on ArgumentError catch (e) {
      print('Invalid argument: ${e.message}');
    } on FormatException catch (e) {
      print('Encoding error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  /// Ask for the password
  static String askPassword(String prompt) {
    stdout.write(prompt);
    stdin.echoMode = false; // hide the password entrance
    final password = stdin.readLineSync() ?? '';
    stdin.echoMode = true;
    stdout.writeln();
    return password;
  }
}
