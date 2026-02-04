/// Represents application settings and business preferences
class AppSettings {
  /// Business Information
  final String storeName;
  final String? storeAddress;
  final String? storePhone;
  final double? taxRate; // VAT percentage (e.g., 13.0 for 13%)

  /// Application Preferences
  final String themeMode; // 'system', 'light', 'dark'
  final String language; // 'en' for English, 'ne' for Nepali
  final String currency; // 'NPR', 'USD', etc.
  final bool lowStockAlerts;
  final bool dailyReportNotifications;

  /// Data Management
  final bool autoSync;
  final DateTime? lastBackupTime;

  /// App Info
  final String version;

  const AppSettings({
    required this.storeName,
    this.storeAddress,
    this.storePhone,
    this.taxRate = 13.0,
    this.themeMode = 'system',
    this.language = 'en',
    this.currency = 'NPR',
    this.lowStockAlerts = true,
    this.dailyReportNotifications = true,
    this.autoSync = true,
    this.lastBackupTime,
    this.version = '0.1.0',
  });

  /// Create a copy of settings with optional field overrides
  AppSettings copyWith({
    String? storeName,
    String? storeAddress,
    String? storePhone,
    double? taxRate,
    String? themeMode,
    String? language,
    String? currency,
    bool? lowStockAlerts,
    bool? dailyReportNotifications,
    bool? autoSync,
    DateTime? lastBackupTime,
    String? version,
  }) {
    return AppSettings(
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      storePhone: storePhone ?? this.storePhone,
      taxRate: taxRate ?? this.taxRate,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      lowStockAlerts: lowStockAlerts ?? this.lowStockAlerts,
      dailyReportNotifications:
          dailyReportNotifications ?? this.dailyReportNotifications,
      autoSync: autoSync ?? this.autoSync,
      lastBackupTime: lastBackupTime ?? this.lastBackupTime,
      version: version ?? this.version,
    );
  }
}
