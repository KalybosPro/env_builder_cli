## 1.0.0

- Initial version.

## 1.0.0+1

- README modified.
- LICENSE changed.

## 1.1.0

- Added environment file encryption/decryption with AES
- Improved error handling for invalid/corrupted files
- Updated README with usage examples

## 1.1.1

- Ask a user if he want to encrypt .env files in his env package
- Bug fixed

## 1.1.2

- Refactored code structure for improved maintainability
- Updated example package structure
- Modified the env package generation's command

## 1.1.3

- `--output-dir`: Custom output directory (default: `env`)
- `--no-encrypt`: Skip encryption of sensitive variables
- `--verbose`: Detailed output during build process

## 1.1.4

- Added APK build command (`env_builder apk`) for building Flutter APKs with release obfuscation
- Added AAB build command (`env_builder aab`) for building Flutter AABs with release obfuscation

## 1.1.5

- Refactored command structure: made `apk` and `aab` commands top-level instead of subcommands of `build`
