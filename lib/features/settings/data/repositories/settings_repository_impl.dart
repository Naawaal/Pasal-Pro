import 'package:pasal_pro/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:pasal_pro/features/settings/data/models/app_settings_model.dart';
import 'package:pasal_pro/features/settings/domain/entities/app_settings.dart';
import 'package:pasal_pro/features/settings/domain/repositories/settings_repository.dart';

/// Concrete implementation of SettingsRepository
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<AppSettings> getSettings() async {
    final model = await _localDataSource.getSettings();
    return model.toEntity();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final model = AppSettingsModel.fromEntity(settings);
    await _localDataSource.saveSettings(model);
  }

  @override
  Future<T?> getSetting<T>(String key) async {
    return await _localDataSource.getSetting<T>(key);
  }

  @override
  Future<void> setSetting<T>(String key, T value) async {
    await _localDataSource.setSetting<T>(key, value);
  }
}
