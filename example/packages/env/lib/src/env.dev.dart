import 'package:envied/envied.dart';

part 'env.dev.g.dart';

@Envied(path: '.env.development', obfuscate: true)
abstract class EnvDev {
  /// The value for Base Url.
@EnviedField(varName: 'BASE_URL', obfuscate: true)
static final String baseUrl = _EnvDev.baseUrl;

/// The value for Api Key.
@EnviedField(varName: 'API_KEY', obfuscate: true)
static final String apiKey = _EnvDev.apiKey;

/// The value for Login Url.
@EnviedField(varName: 'LOGIN_URL', obfuscate: true)
static final String loginUrl = _EnvDev.loginUrl;

/// The value for Register Url.
@EnviedField(varName: 'REGISTER_URL', obfuscate: true)
static final String registerUrl = _EnvDev.registerUrl;

/// The value for Create User Url.
@EnviedField(varName: 'CREATE_USER_URL', obfuscate: true)
static final String createUserUrl = _EnvDev.createUserUrl;

}
