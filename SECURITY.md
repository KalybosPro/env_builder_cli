# Security Policy

## Supported Versions

This Security Policy applies to the following versions of Env Builder CLI:

| Version | Supported          |
| ------- | ------------------ |
| 1.1.x   | :white_check_mark: |
| 1.0.x   | :x:                |
| < 1.0   | :x:                |

We recommend using the latest version for the most secure experience.

## Reporting a Security Vulnerability

The Env Builder CLI team takes security seriously. If you believe you've found a security vulnerability, we encourage you to responsibly disclose it to us.

**Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.**

### How to Report

1. Create a private advisory on GitHub (if you're a contributor with write access) or email the maintainers at [insert secure email here or use GitHub issues with clear marking].

2. Provide detailed information about the vulnerability:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Any suggested fixes or mitigations

### When to Expect a Response

- **Acknowledgment**: Within 3 business days
- **Investigation**: We will investigate all legitimate reports and strive to respond within 7-10 days
- **Resolution**: We'll work on fixes and keep you updated on our progress

We kindly ask that you give us reasonable time to respond and address the issue before publicly disclosing it.

## Scope

This Security Policy is intended to cover Env Builder CLI itself and its core functionality including:

- Environment file parsing
- Package generation
- Encryption and decryption operations
- CLI command processing

This policy does not cover third-party dependencies. For vulnerabilities in dependencies like `encrypt` or `crypto`, please report them directly to the respective maintainers.

### Out of Scope

- Vulnerabilities in third-party packages or libraries
- Issues related to improper usage of the tool (e.g., committing .env files)
- General questions or feature requests

## Security Considerations for Users

As Env Builder CLI deals with sensitive environment data:

1. **Never commit sensitive data** to version control
2. **Use strong encryption keys** and rotate them regularly
3. **Limit access** to decryption keys to essential personnel only
4. **Verify checksums** when downloading the CLI binary
5. **Keep the tool updated** to benefit from security patches

## Security Updates

Security updates will be released as patch versions (e.g., 1.1.1). We will announce critical security updates through:

- GitHub Releases
- Changelog.md
- Relevant community channels

### How to Stay Secure

- Subscribe to our GitHub Releases
- Regularly update to the latest version
- Follow security best practices mentioned in our README.md

## Contact

If you have questions about this Security Policy or concerns about security, please contact us via GitHub issues or email the maintainers.
