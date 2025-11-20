# Release Notes - Env Builder CLI

## v1.1.5 (Latest)

**Release Date:** 20/11/2025

### Changes
- **Command Structure Refactoring**: Reorganized the command structure to make `apk` and `aab` commands independent top-level commands instead of being subcommands of the `build` command.
  - Before: `env_builder build apk`, `env_builder build aab`
  - After: `env_builder apk`, `env_builder aab`
- **Build Command Fix**: Fixed issue where running `env_builder build --env-file=.env` without a subcommand would result in "Missing subcommand" error. Now the build command can be used directly for generating env packages.

### New Usage
```bash
# Build env package
env_builder build --env-file=.env

# Build APK
env_builder apk

# Build AAB
env_builder aab
```

### Previous Versions

#### v1.1.4
- Added APK build command (`env_builder apk`) for building Flutter APKs with release obfuscation
- Added AAB build command (`env_builder aab`) for building Flutter AABs with release obfuscation

#### v1.1.3
- Added `--output-dir` option for custom output directories
- Added `--no-encrypt` flag to skip sensitive variable encryption
- Added `--verbose` flag for detailed build output

#### v1.1.2
- Refactored code structure for improved maintainability
- Updated example package structure
- Modified env package generation process

#### v1.1.1
- Added user prompt for .env file encryption
- Fixed bugs

#### v1.1.0
- Added environment file encryption/decryption with AES
- Improved error handling for invalid/corrupted files
- Updated README with usage examples

#### v1.0.0
- Initial release with basic env package generation functionality
