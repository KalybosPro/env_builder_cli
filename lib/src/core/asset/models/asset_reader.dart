import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import 'models.dart';

/// Asset reader for scanning and processing assets
class AssetReader {
  static const List<String> _imageExtensions = ['png', 'jpg', 'jpeg', 'gif', 'webp'];
  static const List<String> _videoExtensions = ['mp4', 'webm', 'mov', 'avi', 'mkv'];
  static const List<String> _svgExtensions = ['svg'];

  /// Scan assets directory and return all valid asset files
  static List<AssetFile> scanAssetsDirectory(String assetsDir) {
    final assets = <AssetFile>[];
    final directory = Directory(assetsDir);

    if (!directory.existsSync()) {
      return assets;
    }

    final entities = directory.listSync(recursive: true);

    for (final entity in entities) {
      if (entity is File) {
        final assetFile = _createAssetFile(entity);
        if (assetFile != null) {
          assets.add(assetFile);
        }
      }
    }

    return assets;
  }

  /// Create AssetFile from File entity
  static AssetFile? _createAssetFile(File file) {
    final path = file.path;
    final extension = p.extension(path).toLowerCase().replaceFirst('.', '');
    final name = p.basename(path);

    // Skip hidden files and files without extensions
    if (name.startsWith('.') || extension.isEmpty) {
      return null;
    }

    final type = _determineAssetType(extension);
    if (type == AssetType.unknown) {
      return null;
    }

    final stat = file.statSync();

    return AssetFile(
      path: path,
      name: name,
      extension: extension,
      type: type,
      size: stat.size,
      lastModified: stat.modified,
    );
  }

  /// Determine asset type from file extension
  static AssetType _determineAssetType(String extension) {
    if (_imageExtensions.contains(extension)) {
      return AssetType.image;
    } else if (_videoExtensions.contains(extension)) {
      return AssetType.video;
    } else if (_svgExtensions.contains(extension)) {
      return AssetType.svg;
    }
    return AssetType.unknown;
  }

  /// Read asset file in chunks to avoid memory issues
  static Stream<List<int>> readAssetInChunks(String path, {int chunkSize = 64 * 1024}) async* {
    final file = File(path);
    final raf = await file.open();

    try {
      final fileSize = await raf.length();
      var bytesRead = 0;

      while (bytesRead < fileSize) {
        final remaining = fileSize - bytesRead;
        final readSize = remaining < chunkSize ? remaining : chunkSize;

        final buffer = List<int>.filled(readSize, 0);
        final readResult = await raf.readInto(buffer);

        if (readResult == 0) break;

        yield buffer.sublist(0, readResult);
        bytesRead += readResult;
      }
    } finally {
      await raf.close();
    }
  }

  /// Process SVG content for minification
  static String minifySvg(String svgContent) {
    try {
      // Simple string-based minification
      var minified = svgContent;

      // Remove XML comments
      minified = minified.replaceAll(RegExp(r'<!--[\s\S]*?-->'), '');

      // Remove unnecessary whitespace between tags
      minified = minified.replaceAll(RegExp(r'>\s+<'), '><');

      // Remove leading/trailing whitespace from lines
      minified = minified.split('\n').map((line) => line.trim()).join('\n');

      // Remove empty lines
      minified = minified.replaceAll(RegExp(r'\n\s*\n'), '\n');

      return minified.trim();
    } catch (e) {
      // If processing fails, return original content
      return svgContent;
    }
  }

  /// Compress image data
  static List<int> compressImage(List<int> bytes, String extension) {
    try {
      final image = img.decodeImage(Uint8List.fromList(bytes));
      if (image == null) return bytes;

      // Compress based on format
      switch (extension.toLowerCase()) {
        case 'png':
          return img.encodePng(image, level: 6).toList();
        case 'jpg':
        case 'jpeg':
          return img.encodeJpg(image, quality: 85).toList();
        default:
          return bytes;
      }
    } catch (e) {
      return bytes;
    }
  }
}
