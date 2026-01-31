import 'package:shared_preferences/shared_preferences.dart';

/// Persists theme mode. Non-sensitive.
class ThemeStorage {
  ThemeStorage({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;
  static const _keyThemeMode = 'theme_mode';

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<String?> getThemeMode() async {
    return (await _instance).getString(_keyThemeMode);
  }

  Future<void> setThemeMode(String mode) async {
    await (await _instance).setString(_keyThemeMode, mode);
  }
}
