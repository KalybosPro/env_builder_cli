import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:env_builder_cli/src/core/asset/models/encrypted_asset.dart';
import 'package:env_builder_cli/src/core/asset/models/encryption_method.dart';

/// Asset cryptography utilities
class AssetCrypto {
  static final Random _random = Random.secure();

  /// Encrypt asset data using XOR method
  static EncryptedAsset encryptXor(List<int> data) {
    final key = _generateRandomKey(data.length);
    final encrypted = <int>[];

    for (var i = 0; i < data.length; i++) {
      encrypted.add(data[i] ^ key[i % key.length]);
    }

    final hash = _calculateHash(data);

    return EncryptedAsset(
      key: key,
      data: encrypted,
      hash: hash,
    );
  }

  /// Encrypt asset data using AES method
  static EncryptedAsset encryptAes(List<int> data) {
    final key = _generateAesKey();
    final iv = _generateAesIv();

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encryptBytes(data, iv: iv);

    // Combine IV and encrypted data
    final combinedData = iv.bytes + encrypted.bytes;

    final hash = _calculateHash(data);

    return EncryptedAsset(
      key: key.bytes,
      data: combinedData,
      hash: hash,
    );
  }

  /// Decrypt XOR encrypted data
  static List<int> decryptXor(List<int> key, List<int> data) {
    final decrypted = <int>[];

    for (var i = 0; i < data.length; i++) {
      decrypted.add(data[i] ^ key[i % key.length]);
    }

    return decrypted;
  }

  /// Decrypt AES encrypted data
  static List<int> decryptAes(List<int> keyBytes, List<int> data) {
    final key = encrypt.Key(Uint8List.fromList(keyBytes));
    final iv = encrypt.IV(Uint8List.fromList(data.sublist(0, 16))); // First 16 bytes are IV
    final encryptedData = encrypt.Encrypted(Uint8List.fromList(data.sublist(16)));

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decryptBytes(encryptedData, iv: iv);

    return decrypted;
  }

  /// Generate random key for XOR encryption
  static List<int> _generateRandomKey(int length) {
    final key = <int>[];
    for (var i = 0; i < length; i++) {
      key.add(_random.nextInt(256));
    }
    return key;
  }

  /// Generate AES key
  static encrypt.Key _generateAesKey() {
    final keyBytes = List<int>.generate(32, (_) => _random.nextInt(256));
    return encrypt.Key(Uint8List.fromList(keyBytes));
  }

  /// Generate AES IV
  static encrypt.IV _generateAesIv() {
    final ivBytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return encrypt.IV(Uint8List.fromList(ivBytes));
  }

  /// Calculate SHA-256 hash of data
  static String _calculateHash(List<int> data) {
    final digest = sha256.convert(data);
    return digest.toString();
  }

  /// Obfuscate key data to make it less obvious
  static String obfuscateKey(List<int> key) {
    // Simple obfuscation: reverse and base64 encode
    final reversed = key.reversed.toList();
    final encoded = base64Encode(reversed);
    return encoded;
  }

  /// Deobfuscate key data
  static List<int> deobfuscateKey(String obfuscatedKey) {
    // Reverse the obfuscation
    final decoded = base64Decode(obfuscatedKey);
    return decoded.reversed.toList();
  }

  /// Encrypt asset based on method
  static EncryptedAsset encryptAsset(List<int> data, EncryptionMethod method) {
    switch (method) {
      case EncryptionMethod.xor:
        return encryptXor(data);
      case EncryptionMethod.aes:
        return encryptAes(data);
    }
  }

  /// Decrypt asset based on method
  static List<int> decryptAsset(List<int> key, List<int> data, EncryptionMethod method) {
    switch (method) {
      case EncryptionMethod.xor:
        return decryptXor(key, data);
      case EncryptionMethod.aes:
        return decryptAes(key, data);
    }
  }
}
