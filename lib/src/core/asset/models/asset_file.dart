import 'package:path/path.dart' as p;

import 'models.dart' show AssetType;

/// Asset file information
class AssetFile {
  final String path;
  final String name;
  final String extension;
  final AssetType type;
  final int size;
  final DateTime lastModified;

  AssetFile({
    required this.path,
    required this.name,
    required this.extension,
    required this.type,
    required this.size,
    required this.lastModified,
  });

  String get variableName {
    // Convert filename to camelCase variable name
    final baseName = p.basenameWithoutExtension(name);
    final parts = baseName.split(RegExp(r'[\s_-]+'));
    final camelCase = parts
        .map((part) => part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join('');

    // Ensure it starts with lowercase
    return camelCase.isNotEmpty ? camelCase[0].toLowerCase() + camelCase.substring(1) : 'asset';
  }
}
