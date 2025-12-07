// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  EnvBuilder
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as p;
import 'package:vector_graphics/vector_graphics_compat.dart' as _vgc;

import 'assets.g.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images\homescreen.png
  AssetGenImage get homescreen => AssetGenImage(ghomescreen);
  /// File path: assets/images\icon.svg
  SvgGenImage get icon => SvgGenImage(gicon);
  /// File path: assets/images\logo.png
  AssetGenImage get logo => AssetGenImage(glogo);

  /// List of all assets
  List<dynamic> get values => [homescreen, icon, logo];
}

class Assets {
  const Assets._();

  static const String package = 'app_assets';

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._bytes, {this.size, this.flavors = const {}});

  final Uint8List _bytes;

  static const String package = 'app_assets';

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double scale= 1.0,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.memory(
      _bytes,
      key: key,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    double scale = 1.0,
  }) {
    return MemoryImage(_bytes, scale: scale);
  }

}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}});

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;
  final Size? size;
  final Set<String> flavors;

  static const String package = 'app_assets';

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    bool cacheColorFilter = false,
    Widget Function(BuildContext, Object, StackTrace)? errorBuilder,
    _svg.ColorMapper? colorMapper,
    _vgc.RenderingStrategy renderingStrategy = _vgc.RenderingStrategy.picture,
  }) {
    return _svg.SvgPicture.string(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
      theme: theme,
      errorBuilder: errorBuilder,
      colorMapper: colorMapper,
      renderingStrategy: renderingStrategy,
    );
  }

p.Svg get provider => p.Svg('${_assetName.hashCode}.svg',
      source: p.SvgSource.asset,
      svgGetter: (key) => Future.value(_assetName));
}
