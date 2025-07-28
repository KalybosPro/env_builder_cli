import 'package:envied/envied.dart';

part 'env.prod.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class EnvProd {
  /// The value for Base Url.
@EnviedField(varName: 'BASE_URL', obfuscate: true)
static final String baseUrl = _EnvProd.baseUrl;

/// The value for Api Key.
@EnviedField(varName: 'API_KEY', obfuscate: true)
static final String apiKey = _EnvProd.apiKey;

/// The value for Login Url.
@EnviedField(varName: 'LOGIN_URL', obfuscate: true)
static final String loginUrl = _EnvProd.loginUrl;

/// The value for Register Url.
@EnviedField(varName: 'REGISTER_URL', obfuscate: true)
static final String registerUrl = _EnvProd.registerUrl;

}
