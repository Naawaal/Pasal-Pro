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

/// Implementation using in-memory store (can be replaced with SharedPreferences)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  // In-memory store - replace with SharedPreferences in production
  static final Map<String, dynamic> _store = {
    'settings': AppSettingsModel(
      storeName: 'Pasal Pro Store',
      storeAddress: 'Kathmandu, Nepal',
      storePhone: '+977 9841234567',
      taxRate: 13.0,
      themeMode: 'system',
    ).toJson(),
  };

  @override
  Future<AppSettingsModel> getSettings() async {
    try {
      final settingsJson = _store['settings'] as Map<String, dynamic>?;
      if (settingsJson != null) {
        return AppSettingsModel.fromJson(settingsJson);
      }
      // Return default settings
      return AppSettingsModel(storeName: 'Pasal Pro Store');
    } catch (e) {
      return AppSettingsModel(storeName: 'Pasal Pro Store');
    }
  }

  @override
  Future<void> saveSettings(AppSettingsModel settings) async {
    _store['settings'] = settings.toJson();
  }

  @override
  Future<T?> getSetting<T>(String key) async {
    return _store[key] as T?;
  }

  @override
  Future<void> setSetting<T>(String key, T value) async {
    _store[key] = value;
  }
}
