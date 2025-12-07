# Release Notes - Env Builder CLI

## v1.1.6 (Latest)

**Release Date:** 12/07/2025

### 🚀 New Features
- **Assets Command**: New `env_builder assets` command for encrypting and embedding assets directly into Dart code
  - **Asset Discovery**: Automatically scans `assets/` directory for supported files
  - **Multi-format Support**: Images (PNG, JPG, JPEG, GIF, WebP), Videos (MP4, WebM, MOV, AVI, MKV), and SVGs
  - **Compression & Optimization**: Automatic image compression and SVG minification (configurable)
  - **Encryption Options**: XOR (fast, default) and AES (secure) encryption methods
  - **Zero Runtime Dependencies**: Assets embedded as constants, no pubspec.yaml changes needed

### 🔧 Generated APIs
- **Raw Access**: Direct access to encrypted asset data (Uint8List/String)
- **Widget Helpers**: Pre-built widgets for images, SVGs, and video controllers
- **Flutter_gen Compatible**: Drop-in replacement API with the same structure as flutter_gen

### 📖 Usage Examples
```bash
# Encrypt and embed assets with XOR encryption (default)
env_builder assets

# Use AES encryption for sensitive assets
env_builder assets --encrypt=aes

# Skip compression and minification
env_builder assets --no-compress

# Verbose output during generation
env_builder assets --verbose
```

### 💻 Generated Code Usage
```dart
import 'package:app_assets/src/generated/assets.gen.dart';

// Access encrypted assets
final logoBytes = Assets.logo; // Uint8List
final videoPlayer = await Assets.videos.intro.video(); // VideoPlayer widget
final svgPicture = Assets.svgs.icon.svg(); // SvgPicture widget

// Flutter_gen compatible API
final image = Assets.images.logo; // AssetGenImage
```

### 🔒 Security & Performance
- **Encrypted Storage**: All assets are encrypted before embedding
- **Type Safety**: Compile-time safe access prevents typos
- **No Runtime Overhead**: Assets loaded from memory, no file I/O operations
- **Build-time Only**: Encryption/decryption happens at build time only

### 📋 Compatibility
- **Dart SDK**: ^3.8.1+
- **Flutter**: Compatible with existing projects
- **Backward Compatible**: All existing features remain unchanged
