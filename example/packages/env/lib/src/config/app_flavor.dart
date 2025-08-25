import 'package:env/env.dart';

enum Flavor { development, production, staging }

sealed class AppEnv {
  const AppEnv();

  String getEnv(Env env);
}

class AppFlavor extends AppEnv {
  factory AppFlavor.development() =>
      const AppFlavor._(flavor: Flavor.development);

  factory AppFlavor.production() =>
      const AppFlavor._(flavor: Flavor.production);

  factory AppFlavor.staging() => const AppFlavor._(flavor: Flavor.staging);

  const AppFlavor._({required this.flavor});

  final Flavor flavor;

  @override
  String getEnv(Env env) => switch (env) {
    Env.baseUrl => switch (flavor) {
      Flavor.development => EnvDev.baseUrl,

      Flavor.production => EnvProd.baseUrl,

      Flavor.staging => EnvStg.baseUrl,
    },

    Env.apiKey => switch (flavor) {
      Flavor.development => EnvDev.apiKey,

      Flavor.production => EnvProd.apiKey,

      Flavor.staging => EnvStg.apiKey,
    },

    Env.loginUrl => switch (flavor) {
      Flavor.development => EnvDev.loginUrl,

      Flavor.production => EnvProd.loginUrl,

      Flavor.staging => EnvStg.loginUrl,
    },

    Env.registerUrl => switch (flavor) {
      Flavor.development => EnvDev.registerUrl,

      Flavor.production => EnvProd.registerUrl,

      Flavor.staging => EnvStg.registerUrl,
    },

    Env.createUserUrl => switch (flavor) {
      Flavor.development => EnvDev.createUserUrl,

      Flavor.production => EnvProd.createUserUrl,

      Flavor.staging => EnvStg.createUserUrl,
    },
  };
}
