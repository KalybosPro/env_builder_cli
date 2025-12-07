🚀 Révolutionnez la gestion des environnements dans vos apps Flutter avec env_builder_cli ! 🇫🇷

Je suis fier de partager cet outil Dart puissant qui automatise la création et la maintenance des packages d'environnement pour vos applications Flutter. Générons ensemble du code type-safe à partir de fichiers .env avec support de cryptage intégré !

## 🔄 Génération Automatisée de Package Environnement
**Usage:** `env_builder build`
**Exemple utile:** Dans votre projet Flutter, exécutez cette commande pour créer automatiquement un package `packages/env` avec des classes Dart pour accéder à vos variables d'environnement de manière type-safe.

## 🔐 Cryptage AES Intégré
**Usage:** `env_builder build --no-encrypt` (pour désactiver) ou défaut activé
**Exemple utile:** Vos clés API sensibles comme `API_KEY=prod_key_456` sont automatiquement cryptées avec AES, rendant les fichiers .env committables en toute sécurité.

## 📝 Accès Type-Safe
**Usage:** Utilisation des classes générées par Envied
**Exemple utile:**
```dart
final EnvValue env = AppFlavor.production().getEnv;

String get baseUrl => env(Env.baseUrl);
```
Plus de risques d'erreurs de typage à l'exécution !

## 🏗️ Intégration Flutter Seamless
**Usage:** Automatique via `flutter pub get`
**Exemple utile:** Le package env est automatiquement ajouté aux dépendances de votre pubspec.yaml

## 🔄 Support Multi-Environnements
**Usage:** `env_builder build --env-file=.env.development,.env.production`
**Exemple utile:** Gérez facilement développement, staging, production avec des fichiers distincts .env.development, .env.production, etc.

## 📂 Intégration Git
**Usage:** Automatique lors du build
**Exemple utile:** Le .gitignore est mis à jour automatiquement pour exclure vos .env sensibles mais inclure les .env.encrypted.

## 🧪 Support des Tests
**Usage:** Tests générés automatiquement
**Exemple utile:** Validez vos variables d'environnement avec des tests unitaires générés pour chaque fichier .env.

## 🎨 Cryptage d'Assets
**Usage:** `env_builder assets --encrypt=aes`
**Exemple utile:** Cryptez et embarquez vos images, vidéos et SVGs directement dans le code Dart. Parfait pour protéger vos ressources sensibles !

## 📱 Build APK/AAB avec Obfuscation
**Usage:** `env_builder apk` ou `env_builder aab`
**Exemple utile:** Build de release automatique avec obfuscation pour sécuriser votre code Flutter en production.

## 🔒 Commandes Encrypt/Decrypt
**Usage:** `env_builder encrypt --password=key .env`
**Exemple utile:** Cryptez vos fichiers .env sensibles localement ou dans votre CI/CD.

## 📦 Assets Embarqués (Zero Dépendances)
**Usage:** `env_builder assets`
**Exemple utile:** Vos assets deviennent des constantes Uint8List dans le code, pas besoin de pubspec.yaml !

```dart
// Utilisation directe
final logoBytes = Assets.logo; // Uint8List
// Avec widgets pré-construits
Assets.images.logo.image(), // Image widget
```

Installez-le aujourd'hui: `dart pub global activate env_builder_cli`

👉 Découvrez la doc complète et l'exemple: https://github.com/KalybosPro/env_builder_cli

#Flutter #Dart #DevTools #MobileDev #FlutterDeveloper #EnvVar #Security

Avez-vous déjà galéré avec la gestion des environnements dans Flutter ? Ce tool pourrait révolutionner votre workflow ! 💪
