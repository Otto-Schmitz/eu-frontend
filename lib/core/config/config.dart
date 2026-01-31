/// App config. Edit [defaultApiBaseUrl] for local/dummy API.
///
/// Production: use --dart-define=API_BASE_URL=... when building.
library;

class Config {
  Config._();

  /// Dummy/development API base URL (no trailing slash).
  static const String defaultApiBaseUrl = 'http://localhost:8080';
}
