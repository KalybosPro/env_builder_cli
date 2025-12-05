import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'asset.dart';
import 'asset.dart' as asset_reader;
import 'package:path/path.dart' as p;

/// Generator for assets.g.dart file
class AssetsGenerator {
  final bool compress;
  final bool svgMinify;
  final EncryptionMethod encryptionMethod;
  final int chunkSize;

  AssetsGenerator({
    required this.compress,
    required this.svgMinify,
    required this.encryptionMethod,
    required this.chunkSize,
  });

  Future<String> generate() async {
    // Use the actual file system path to find assets
    final assetsDir = p.join(Directory.current.path, 'assets');

    print('AssetsGenerator: Looking for assets in: $assetsDir');
    final assets = asset_reader.AssetReader.scanAssetsDirectory(assetsDir);
    print('AssetsGenerator: Found ${assets.length} assets');
    if (assets.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln();
    buffer.writeln("import 'dart:typed_data';");
    if (encryptionMethod == EncryptionMethod.aes) {
      buffer.writeln("import 'package:encrypt/encrypt.dart' as encrypt;");
    }
    buffer.writeln();
    buffer.writeln('// ignore_for_file: constant_identifier_names');
    buffer.writeln();

    for (final asset in assets) {
      try {
        final encryptedAsset = await _processAsset(asset);

        // Generate key constant
        buffer.writeln(
          'const List<int> _assetkey${asset.variableName} = <int>${_formatByteList(encryptedAsset.key)};',
        );

        // Generate data constant
        buffer.writeln(
          'const List<int> assetdata${asset.variableName} = <int>${_formatByteList(encryptedAsset.data)};',
        );

        // Generate decrypted asset getter
        if (asset.type == asset_reader.AssetType.svg) {
          buffer.writeln(
            'String get g${asset.variableName} => String.fromCharCodes(${_generateDecryptCall(asset.variableName, encryptionMethod)});',
          );
        } else {
          buffer.writeln(
            'Uint8List get g${asset.variableName} => Uint8List.fromList(${_generateDecryptCall(asset.variableName, encryptionMethod)});',
          );
        }

        buffer.writeln();
      } catch (e) {
        print('Error processing asset ${asset.path}: $e');
        // Continue with other assets
      }
    }

    // Generate utility methods
    _generateUtilityMethods(buffer, encryptionMethod);

    return buffer.toString();
  }

  Future<EncryptedAsset> _processAsset(asset_reader.AssetFile asset) async {
    final bytes = await _readAssetBytes(asset);

    // Process based on type
    List<int> processedBytes;
    if (asset.type == asset_reader.AssetType.svg) {
      // For SVG files, ensure proper UTF-8 encoding
      final normalizedSvgBytes = _normalizeSvgEncoding(bytes);
      final svgContent = utf8.decode(normalizedSvgBytes);

      if (svgMinify) {
        processedBytes = utf8.encode(
          asset_reader.AssetReader.minifySvg(svgContent),
        );
      } else {
        processedBytes = normalizedSvgBytes;
      }
    } else if ((asset.type == asset_reader.AssetType.image) && compress) {
      processedBytes = asset_reader.AssetReader.compressImage(
        bytes,
        asset.extension,
      );
    } else {
      processedBytes = bytes;
    }

    // Encrypt
    return AssetCrypto.encryptAsset(processedBytes, encryptionMethod);
  }

  Future<List<int>> _readAssetBytes(asset_reader.AssetFile asset) async {
    final bytes = <int>[];
    await for (final chunk in asset_reader.AssetReader.readAssetInChunks(
      asset.path,
      chunkSize: chunkSize * 1024,
    )) {
      bytes.addAll(chunk);
    }
    return bytes;
  }

  /// Normalize SVG encoding to UTF-8
  ///
  /// Handles different text encodings that SVG files might have:
  /// - UTF-16 with BOM (common on Windows)
  /// - UTF-8 (standard for web)
  List<int> _normalizeSvgEncoding(List<int> bytes) {
    // Check for UTF-16 LE BOM (0xFF 0xFE)
    if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
      // Remove BOM and convert UTF-16 LE to string
      final utf16Bytes = bytes.sublist(2);
      final content = _decodeUtf16LE(utf16Bytes);
      return utf8.encode(content);
    }

    // Check for UTF-16 BE BOM (0xFE 0xFF)
    if (bytes.length >= 2 && bytes[0] == 0xFE && bytes[1] == 0xFF) {
      // Remove BOM and convert UTF-16 BE to string
      final utf16Bytes = bytes.sublist(2);
      final content = _decodeUtf16BE(utf16Bytes);
      return utf8.encode(content);
    }

    // Try to decode as UTF-8, if it fails, assume it's already UTF-8 bytes
    try {
      utf8.decode(bytes);
      return bytes; // Already valid UTF-8
    } catch (e) {
      // If UTF-8 decoding fails, try to interpret as Latin-1 and re-encode as UTF-8
      try {
        final content = String.fromCharCodes(bytes);
        return utf8.encode(content);
      } catch (e) {
        // Last resort: return as-is
        return bytes;
      }
    }
  }

  /// Decode UTF-16 LE bytes to string
  String _decodeUtf16LE(List<int> bytes) {
    final codeUnits = <int>[];
    for (var i = 0; i < bytes.length; i += 2) {
      if (i + 1 < bytes.length) {
        // Little-endian: low byte first
        final low = bytes[i];
        final high = bytes[i + 1];
        final codeUnit = (high << 8) | low;
        codeUnits.add(codeUnit);
      }
    }
    return String.fromCharCodes(codeUnits);
  }

  /// Decode UTF-16 BE bytes to string
  String _decodeUtf16BE(List<int> bytes) {
    final codeUnits = <int>[];
    for (var i = 0; i < bytes.length; i += 2) {
      if (i + 1 < bytes.length) {
        // Big-endian: high byte first
        final high = bytes[i];
        final low = bytes[i + 1];
        final codeUnit = (high << 8) | low;
        codeUnits.add(codeUnit);
      }
    }
    return String.fromCharCodes(codeUnits);
  }

  String _formatByteList(List<int> bytes) {
    if (bytes.length <= 100) {
      // Small lists can be formatted on one line
      return '[${bytes.join(', ')}]';
    } else {
      // Large lists should be formatted with line breaks for readability
      final buffer = StringBuffer('[\n');
      for (var i = 0; i < bytes.length; i += 20) {
        final end = (i + 20 < bytes.length) ? i + 20 : bytes.length;
        buffer.write('  ${bytes.sublist(i, end).join(', ')},\n');
      }
      buffer.write(']');
      return buffer.toString();
    }
  }

  String _generateDecryptCall(String variableName, EncryptionMethod method) {
    switch (method) {
      case EncryptionMethod.xor:
        return '_decryptXor(_assetkey$variableName, assetdata$variableName)';
      case EncryptionMethod.aes:
        return '_decryptAes(_assetkey$variableName, assetdata$variableName)';
    }
  }

  void _generateUtilityMethods(StringBuffer buffer, EncryptionMethod method) {
    switch (method) {
      case EncryptionMethod.xor:
        buffer.writeln(
          'List<int> _decryptXor(List<int> key, List<int> data) {',
        );
        buffer.writeln('  final decrypted = <int>[];');
        buffer.writeln('  for (var i = 0; i < data.length; i++) {');
        buffer.writeln('    decrypted.add(data[i] ^ key[i % key.length]);');
        buffer.writeln('  }');
        buffer.writeln('  return decrypted;');
        buffer.writeln('}');
        break;

      case EncryptionMethod.aes:
        buffer.writeln(
          'List<int> _decryptAes(List<int> key, List<int> data) {',
        );
        buffer.writeln('  final keyObj = encrypt.Key(Uint8List.fromList(key));');
        buffer.writeln('  final iv = encrypt.IV(Uint8List.fromList(data.sublist(0, 16)));');
        buffer.writeln('  final encryptedData = encrypt.Encrypted(Uint8List.fromList(data.sublist(16)));');
        buffer.writeln('  final encrypter = encrypt.Encrypter(encrypt.AES(keyObj));');
        buffer.writeln('  final decrypted = encrypter.decryptBytes(encryptedData, iv: iv);');
        buffer.writeln('  return decrypted;');
        buffer.writeln('}');
        break;
    }
  }
}
