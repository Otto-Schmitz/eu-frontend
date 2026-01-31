/// App configuration. Use --dart-define=API_BASE_URL=... for production.
class Env {
  Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const String apiPath = '/api/v1';
  static String get baseUrl => '$apiBaseUrl$apiPath';
}
