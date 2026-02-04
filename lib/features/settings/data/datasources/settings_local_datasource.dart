import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pasal_pro/features/settings/data/models/app_settings_model.dart';

/// Local data source for app settings (using shared_preferences)
abstract class SettingsLocalDataSource {
  /// Get settings from local storage
  Future<AppSettingsModel> getSettings();

  /// Save settings to local storage
  Future<void> saveSettings(AppSettingsModel settings);

  /// Get a specific setting
  Future<T?> getSetting<T>(String key);

  /// Save a specific setting
  Future<void> setSetting<T>(String key, T value);
}

/// Implementation using SharedPreferences for persistent storage
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _settingsKey = 'app_settings';

  @override
  Future<AppSettingsModel> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null && settingsJson.isNotEmpty) {
        // Parse JSON string back to map
        final Map<String, dynamic> decoded = jsonDecode(settingsJson);
        return AppSettingsModel.fromJson(decoded);
      }

      // Return default settings if none exist
      return AppSettingsModel(
        storeName: 'Pasal Pro Store',
        themeMode: 'system',
      );
    } catch (e) {
      // Return default settings on error
      return AppSettingsModel(
        storeName: 'Pasal Pro Store',
        themeMode: 'system',
      );
    }
  }

  @override
  Future<void> saveSettings(AppSettingsModel settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(settings.toJson());
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      // Handle save error
      rethrow;
    }
  }

  @override
  Future<T?> getSetting<T>(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (T == String) {
        return prefs.getString(key) as T?;
      } else if (T == int) {
        return prefs.getInt(key) as T?;
      } else if (T == double) {
        return prefs.getDouble(key) as T?;
      } else if (T == bool) {
        return prefs.getBool(key) as T?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setSetting<T>(String key, T value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      }
    } catch (e) {
      rethrow;
    }
  }
}
