import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences used by every feature that needs
/// on-device persistence (onboarding interests, gamification stats, the
/// onboarding-complete flag). Centralizing it here means features don't
/// each reach for SharedPreferences.getInstance() directly, and it's the
/// one place to swap for e.g. Hive/Isar later if local storage needs grow.
class LocalStorageService {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(key, value);
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _prefs;
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }
}
