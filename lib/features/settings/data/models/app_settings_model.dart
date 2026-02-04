import 'package:pasal_pro/features/settings/domain/entities/app_settings.dart';

/// Data model for app settings
class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.storeName,
    super.storeAddress,
    super.storePhone,
    super.taxRate,
    super.themeMode,
    super.language,
    super.currency,
    super.lowStockAlerts,
    super.dailyReportNotifications,
    super.autoSync,
    super.lastBackupTime,
    super.version,
  });

  /// Create from domain entity
  factory AppSettingsModel.fromEntity(AppSettings entity) {
    return AppSettingsModel(
      storeName: entity.storeName,
      storeAddress: entity.storeAddress,
      storePhone: entity.storePhone,
      taxRate: entity.taxRate,
      themeMode: entity.themeMode,
      language: entity.language,
      currency: entity.currency,
      lowStockAlerts: entity.lowStockAlerts,
      dailyReportNotifications: entity.dailyReportNotifications,
      autoSync: entity.autoSync,
      lastBackupTime: entity.lastBackupTime,
      version: entity.version,
    );
  }

  /// Convert to domain entity
  AppSettings toEntity() {
    return AppSettings(
      storeName: storeName,
      storeAddress: storeAddress,
      storePhone: storePhone,
      taxRate: taxRate,
      themeMode: themeMode,
      language: language,
      currency: currency,
      lowStockAlerts: lowStockAlerts,
      dailyReportNotifications: dailyReportNotifications,
      autoSync: autoSync,
      lastBackupTime: lastBackupTime,
      version: version,
    );
  }

  /// Convert from JSON (for local storage)
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      storeName: json['storeName'] as String? ?? 'Pasal Pro Store',
      storeAddress: json['storeAddress'] as String?,
      storePhone: json['storePhone'] as String?,
      taxRate: json['taxRate'] as double? ?? 13.0,
      themeMode: json['themeMode'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
      currency: json['currency'] as String? ?? 'NPR',
      lowStockAlerts: json['lowStockAlerts'] as bool? ?? true,
      dailyReportNotifications:
          json['dailyReportNotifications'] as bool? ?? true,
      autoSync: json['autoSync'] as bool? ?? true,
      lastBackupTime: json['lastBackupTime'] != null
          ? DateTime.parse(json['lastBackupTime'] as String)
          : null,
      version: json['version'] as String? ?? '0.1.0',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'storeAddress': storeAddress,
      'storePhone': storePhone,
      'taxRate': taxRate,
      'themeMode': themeMode,
      'language': language,
      'currency': currency,
      'lowStockAlerts': lowStockAlerts,
      'dailyReportNotifications': dailyReportNotifications,
      'autoSync': autoSync,
      'lastBackupTime': lastBackupTime?.toIso8601String(),
      'version': version,
    };
  }
}
