import 'package:pasal_pro/features/settings/domain/entities/app_settings.dart';

/// Abstract repository for app settings persistence
abstract class SettingsRepository {
  /// Get current app settings
  Future<AppSettings> getSettings();

  /// Save app settings
  Future<void> saveSettings(AppSettings settings);

  /// Get a specific setting value
  Future<T?> getSetting<T>(String key);

  /// Save a specific setting value
  Future<void> setSetting<T>(String key, T value);
}
