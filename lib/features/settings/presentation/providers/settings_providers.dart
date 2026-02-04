import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:pasal_pro/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:pasal_pro/features/settings/domain/entities/app_settings.dart';
import 'package:pasal_pro/features/settings/domain/repositories/settings_repository.dart';

/// Provide the local data source
final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((
  ref,
) {
  return SettingsLocalDataSourceImpl();
});

/// Provide the repository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final localDataSource = ref.watch(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(localDataSource);
});

/// Get current app settings
final appSettingsProvider = FutureProvider<AppSettings>((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.getSettings();
});

/// State notifier for updating settings
class SettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _initialize();
  }

  /// Initialize settings from repository
  Future<void> _initialize() async {
    try {
      final settings = await _repository.getSettings();
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update store name
  Future<void> updateStoreName(String name) async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      final updated = current.copyWith(storeName: name);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Update store address
  Future<void> updateStoreAddress(String? address) async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      final updated = current.copyWith(storeAddress: address);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Update store phone
  Future<void> updateStorePhone(String? phone) async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      final updated = current.copyWith(storePhone: phone);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Update tax rate
  Future<void> updateTaxRate(double rate) async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      final updated = current.copyWith(taxRate: rate);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Toggle dark mode
  Future<void> toggleThemeMode() async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      // Cycle: system -> light -> dark -> system
      final nextMode = switch (current.themeMode) {
        'light' => 'dark',
        'dark' => 'system',
        _ => 'light',
      };
      final updated = current.copyWith(themeMode: nextMode);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Set theme mode explicitly
  Future<void> setThemeMode(String mode) async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      final updated = current.copyWith(themeMode: mode);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Update language
  Future<void> updateLanguage(String language) async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      final updated = current.copyWith(language: language);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Toggle low stock alerts
  Future<void> toggleLowStockAlerts() async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      final updated = current.copyWith(lowStockAlerts: !current.lowStockAlerts);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Toggle daily report notifications
  Future<void> toggleDailyReportNotifications() async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      final updated = current.copyWith(
        dailyReportNotifications: !current.dailyReportNotifications,
      );
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Toggle auto sync
  Future<void> toggleAutoSync() async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      final updated = current.copyWith(autoSync: !current.autoSync);
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }

  /// Update last backup time
  Future<void> updateLastBackupTime() async {
    final current = state.maybeWhen(data: (s) => s, orElse: () => null);
    if (current != null) {
      final updated = current.copyWith(lastBackupTime: DateTime.now());
      await _repository.saveSettings(updated);
      state = AsyncValue.data(updated);
    }
  }
}

/// State notifier provider for settings
final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>((ref) {
      final repository = ref.watch(settingsRepositoryProvider);
      return SettingsNotifier(repository);
    });
