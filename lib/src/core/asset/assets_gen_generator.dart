import 'dart:async';
import 'dart:io';
import 'asset.dart' as asset_reader;
import 'package:path/path.dart' as p;

/// Generator for assets.gen.dart file (flutter_gen style)
class AssetsGenGenerator {
  Future<String> generate() async {
    print('AssetsGenGenerator: Starting generation');
    // Use the actual file system path to find assets
    final assetsDir = p.join(Directory.current.path, 'assets');
    print('AssetsGenGenerator: Looking for assets in: $assetsDir');

    final assets = asset_reader.AssetReader.scanAssetsDirectory(assetsDir);
    print('AssetsGenGenerator: Found ${assets.length} assets');
    for (final asset in assets) {
      print(
        'AssetsGenGenerator: Asset: ${asset.path}, type: ${asset.type}, var: ${asset.variableName}',
      );
    }
    if (assets.isEmpty) {
      return '';
    }

    // Group assets by directory
    final assetGroups = _groupAssetsByDirectory(assets);
    print('AssetsGenGenerator: Asset groups: ${assetGroups.keys}');
    for (final entry in assetGroups.entries) {
      print(
        'AssetsGenGenerator: Group ${entry.key}: ${entry.value.map((a) => a.variableName)}',
      );
    }

    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('/// *****************************************************');
    buffer.writeln('///  EnvBuilder');
    buffer.writeln('/// *****************************************************');
    buffer.writeln();
    buffer.writeln('// coverage:ignore-file');
    buffer.writeln('// ignore_for_file: type=lint');
    buffer.writeln(
      '// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use',
    );
    buffer.writeln();
    buffer.writeln("import 'package:flutter/services.dart';");
    buffer.writeln("import 'package:flutter/widgets.dart';");
    buffer.writeln("import 'package:flutter_svg/flutter_svg.dart' as _svg;");
    buffer.writeln(
      "import 'package:flutter_svg_provider/flutter_svg_provider.dart' as p;",
    );
    buffer.writeln(
      "import 'package:vector_graphics/vector_graphics_compat.dart' as _vgc;",
    );
    buffer.writeln();
    buffer.writeln("import 'assets.g.dart';");
    buffer.writeln();

    // Generate asset group classes
    final assetGroupClasses = <String>[];
    for (final entry in assetGroups.entries) {
      final groupName = entry.key;
      final groupAssets = entry.value;

      final className = '\$Assets${_capitalize(groupName)}Gen';
      assetGroupClasses.add(className);

      buffer.writeln('class $className {');
      buffer.writeln('  const $className();');
      buffer.writeln();

      final assetGetters = <String>[];
      for (final asset in groupAssets) {
        final getter = _generateAssetGetter(asset);
        buffer.writeln(getter);
        assetGetters.add(_getAssetReference(asset));
      }

      buffer.writeln();
      buffer.writeln('  /// List of all assets');
      buffer.write('  List<dynamic> get values => [');
      buffer.write(assetGetters.join(', '));
      buffer.writeln('];');
      buffer.writeln('}');
      buffer.writeln();
    }

    // Main Assets class
    buffer.writeln('class Assets {');
    buffer.writeln('  const Assets._();');
    buffer.writeln();
    buffer.writeln("  static const String package = 'app_assets';");
    buffer.writeln();

    for (final className in assetGroupClasses) {
      final fieldName = className
          .replaceFirst('\$Assets', '')
          .replaceFirst('Gen', '')
          .toLowerCase();
      buffer.writeln('  static const $className $fieldName = $className();');
    }

    buffer.writeln('}');
    buffer.writeln();

    // AssetGenImage class
    _generateAssetGenImage(buffer);

    // SvgGenImage class
    _generateSvgGenImage(buffer);

    return buffer.toString();
  }

  Map<String, List<asset_reader.AssetFile>> _groupAssetsByDirectory(
    List<asset_reader.AssetFile> assets,
  ) {
    final groups = <String, List<asset_reader.AssetFile>>{};

    for (final asset in assets) {
      // Get relative path from assets directory
      final relativePath = p.relative(
        asset.path,
        from: p.join(Directory.current.path, 'assets'),
      );
      final parts = p.split(relativePath);

      // Use first directory level as group name, or 'misc' if no subdirectory
      final groupName = parts.length > 1
          ? _normalizeGroupName(parts[0])
          : 'misc';

      groups.putIfAbsent(groupName, () => []).add(asset);
    }

    return groups;
  }

  String _normalizeGroupName(String name) {
    // Convert to PascalCase
    return name
        .split(RegExp(r'[\s_-]+'))
        .map(
          (part) => part.isEmpty
              ? ''
              : part[0].toUpperCase() + part.substring(1).toLowerCase(),
        )
        .join('');
  }

  String _capitalize(String s) {
    return s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;
  }

  String _generateAssetGetter(asset_reader.AssetFile asset) {
    final relativePath = p.relative(
      asset.path,
      from: p.join(Directory.current.path, 'assets'),
    );
    final assetPath = 'assets/$relativePath';

    if (asset.type == asset_reader.AssetType.svg) {
      return '  /// File path: $assetPath\n  SvgGenImage get ${asset.variableName} => SvgGenImage(g${asset.variableName});';
    } else {
      return '  /// File path: $assetPath\n  AssetGenImage get ${asset.variableName} => AssetGenImage(g${asset.variableName});';
    }
  }

  String _getAssetReference(asset_reader.AssetFile asset) {
    return asset.variableName;
  }

  void _generateAssetGenImage(StringBuffer buffer) {
    buffer.writeln('class AssetGenImage {');
    buffer.writeln(
      '  const AssetGenImage(this._bytes, {this.size, this.flavors = const {}});',
    );
    buffer.writeln();
    buffer.writeln('  final Uint8List _bytes;');
    buffer.writeln();
    buffer.writeln("  static const String package = 'app_assets';");
    buffer.writeln();
    buffer.writeln('  final Size? size;');
    buffer.writeln('  final Set<String> flavors;');
    buffer.writeln();
    buffer.writeln('  Image image({');
    buffer.writeln('    Key? key,');
    buffer.writeln('    ImageFrameBuilder? frameBuilder,');
    buffer.writeln('    ImageErrorWidgetBuilder? errorBuilder,');
    buffer.writeln('    String? semanticLabel,');
    buffer.writeln('    bool excludeFromSemantics = false,');
    buffer.writeln('    double scale= 1.0,');
    buffer.writeln('    double? width,');
    buffer.writeln('    double? height,');
    buffer.writeln('    Color? color,');
    buffer.writeln('    Animation<double>? opacity,');
    buffer.writeln('    BlendMode? colorBlendMode,');
    buffer.writeln('    BoxFit? fit,');
    buffer.writeln('    AlignmentGeometry alignment = Alignment.center,');
    buffer.writeln('    ImageRepeat repeat = ImageRepeat.noRepeat,');
    buffer.writeln('    Rect? centerSlice,');
    buffer.writeln('    bool matchTextDirection = false,');
    buffer.writeln('    bool gaplessPlayback = true,');
    buffer.writeln('    bool isAntiAlias = false,');
    buffer.writeln('    FilterQuality filterQuality = FilterQuality.medium,');
    buffer.writeln('    int? cacheWidth,');
    buffer.writeln('    int? cacheHeight,');
    buffer.writeln('  }) {');
    buffer.writeln('    return Image.memory(');
    buffer.writeln('      _bytes,');
    buffer.writeln('      key: key,');
    buffer.writeln('      frameBuilder: frameBuilder,');
    buffer.writeln('      errorBuilder: errorBuilder,');
    buffer.writeln('      semanticLabel: semanticLabel,');
    buffer.writeln('      excludeFromSemantics: excludeFromSemantics,');
    buffer.writeln('      scale: scale,');
    buffer.writeln('      width: width,');
    buffer.writeln('      height: height,');
    buffer.writeln('      color: color,');
    buffer.writeln('      opacity: opacity,');
    buffer.writeln('      colorBlendMode: colorBlendMode,');
    buffer.writeln('      fit: fit,');
    buffer.writeln('      alignment: alignment,');
    buffer.writeln('      repeat: repeat,');
    buffer.writeln('      centerSlice: centerSlice,');
    buffer.writeln('      matchTextDirection: matchTextDirection,');
    buffer.writeln('      gaplessPlayback: gaplessPlayback,');
    buffer.writeln('      isAntiAlias: isAntiAlias,');
    buffer.writeln('      filterQuality: filterQuality,');
    buffer.writeln('      cacheWidth: cacheWidth,');
    buffer.writeln('      cacheHeight: cacheHeight,');
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln();
    buffer.writeln('  ImageProvider provider({');
    buffer.writeln('    double scale = 1.0,');
    buffer.writeln('  }) {');
    buffer.writeln('    return MemoryImage(_bytes, scale: scale);');
    buffer.writeln('  }');
    buffer.writeln();
    buffer.writeln('}');
    buffer.writeln();
  }

  void _generateSvgGenImage(StringBuffer buffer) {
    buffer.writeln('class SvgGenImage {');
    buffer.writeln(
      '  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}});',
    );
    buffer.writeln();
    buffer.writeln(
      '  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}});',
    );
    buffer.writeln();
    buffer.writeln('  final String _assetName;');
    buffer.writeln('  final Size? size;');
    buffer.writeln('  final Set<String> flavors;');
    buffer.writeln();
    buffer.writeln("  static const String package = 'app_assets';");
    buffer.writeln();
    buffer.writeln('  _svg.SvgPicture svg({');
    buffer.writeln('    Key? key,');
    buffer.writeln('    bool matchTextDirection = false,');
    buffer.writeln('    double? width,');
    buffer.writeln('    double? height,');
    buffer.writeln('    BoxFit fit = BoxFit.contain,');
    buffer.writeln('    AlignmentGeometry alignment = Alignment.center,');
    buffer.writeln('    bool allowDrawingOutsideViewBox = false,');
    buffer.writeln('    WidgetBuilder? placeholderBuilder,');
    buffer.writeln('    String? semanticsLabel,');
    buffer.writeln('    bool excludeFromSemantics = false,');
    buffer.writeln('    _svg.SvgTheme? theme,');
    buffer.writeln('    ColorFilter? colorFilter,');
    buffer.writeln('    Clip clipBehavior = Clip.hardEdge,');
    buffer.writeln("    Color? color,");
    buffer.writeln("    BlendMode colorBlendMode = BlendMode.srcIn,");
    buffer.writeln("    bool cacheColorFilter = false,");
    buffer.writeln(
      '    Widget Function(BuildContext, Object, StackTrace)? errorBuilder,',
    );
    buffer.writeln('    _svg.ColorMapper? colorMapper,');
    buffer.writeln(
      '    _vgc.RenderingStrategy renderingStrategy = _vgc.RenderingStrategy.picture,',
    );
    buffer.writeln('  }) {');
    buffer.writeln('    return _svg.SvgPicture.string(');
    buffer.writeln('      _assetName,');
    buffer.writeln('      key: key,');
    buffer.writeln('      matchTextDirection: matchTextDirection,');
    buffer.writeln('      width: width,');
    buffer.writeln('      height: height,');
    buffer.writeln('      fit: fit,');
    buffer.writeln('      alignment: alignment,');
    buffer.writeln(
      '      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,',
    );
    buffer.writeln('      placeholderBuilder: placeholderBuilder,');
    buffer.writeln('      semanticsLabel: semanticsLabel,');
    buffer.writeln('      excludeFromSemantics: excludeFromSemantics,');
    buffer.writeln('      colorFilter:');
    buffer.writeln('          colorFilter ??');
    buffer.writeln(
      '          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),',
    );
    buffer.writeln('      clipBehavior: clipBehavior,');
    buffer.writeln('      cacheColorFilter: cacheColorFilter,');
    buffer.writeln('      theme: theme,');
    buffer.writeln('      errorBuilder: errorBuilder,');
    buffer.writeln('      colorMapper: colorMapper,');
    buffer.writeln('      renderingStrategy: renderingStrategy,');
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln();
   
    buffer.writeln('p.Svg provider({');
    buffer.writeln('    Size? size,');
    buffer.writeln('    double scale = 1.0,');
    buffer.writeln('    Color? color,');
    buffer.writeln('    p.SvgSource source = p.SvgSource.asset,');
    buffer.writeln(
      '    Future<String?> Function(p.SvgImageKey)? svgGetter,',
    );
    buffer.writeln('  }) {');
    buffer.writeln('    return p.Svg(');
    buffer.writeln('      _assetName,');
    buffer.writeln('      size: size,');
    buffer.writeln('      scale: scale,');
    buffer.writeln('      color: color,');
    buffer.writeln('      source: source,');
    buffer.writeln('      svgGetter: svgGetter,');
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');
  }
}
