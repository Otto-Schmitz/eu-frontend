/// API configuration.
///
/// Override via: flutter run --dart-define=API_BASE_URL=https://api.example.com
/// Or edit [defaultApiBaseUrl] in config.dart for local development.
library;

import 'config.dart';

class Env {
  Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: Config.defaultApiBaseUrl,
  );

  static const String apiPath = '/api/v1';
  static String get baseUrl => '$apiBaseUrl$apiPath';
}
