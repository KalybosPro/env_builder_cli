import 'package:envied/envied.dart';

part 'env.stg.g.dart';

@Envied(path: '.env.staging', obfuscate: true)
abstract class EnvStg {
  /// The value for Base Url.
@EnviedField(varName: 'BASE_URL', obfuscate: true)
static final String baseUrl = _EnvStg.baseUrl;

/// The value for Api Key.
@EnviedField(varName: 'API_KEY', obfuscate: true)
static final String apiKey = _EnvStg.apiKey;

/// The value for Login Url.
@EnviedField(varName: 'LOGIN_URL', obfuscate: true)
static final String loginUrl = _EnvStg.loginUrl;

/// The value for Register Url.
@EnviedField(varName: 'REGISTER_URL', obfuscate: true)
static final String registerUrl = _EnvStg.registerUrl;

}
