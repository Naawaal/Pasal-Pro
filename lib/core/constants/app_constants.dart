/// Application-wide constants for Pasal Pro
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Pasal Pro';
  static const String appVersion = '0.1.0';
  static const String appTagline = 'Digital Khata for Nepali Shops';

  // Database
  static const String databaseName = 'pasal_pro.isar';
  static const int databaseVersion = 1;

  // Backup
  static const String backupFolderName = 'PasalProBackups';
  static const Duration backupInterval = Duration(hours: 24);
  static const String backupFilePrefix = 'pasal_backup_';

  // UI/UX
  static const Duration animationDuration = Duration(milliseconds: 200);
  static const double borderRadius = 12.0;
  static const double spacing = 16.0;
  static const double minTapTarget = 48.0;

  // Business Rules
  static const int defaultPiecesPerCarton = 12;
  static const double minProfitMarginPercent = 0.0;
  static const int lowStockThreshold = 10;

  // Date/Time Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM d, yyyy';
  static const String displayTimeFormat = 'h:mm a';

  // Currency
  static const String currencySymbol = 'Rs';
  static const String currencyCode = 'NPR';
  static const int decimalPlaces = 2;

  // Printer
  static const int receiptWidth = 32; // Characters per line
  static const String printerDevicePrefix = 'Bluetooth Printer';

  // Performance Targets
  static const Duration maxSaleEntryTime = Duration(seconds: 2);
  static const Duration maxUIResponseTime = Duration(milliseconds: 50);
  static const double targetCrashFreeRate = 0.999;

  // Validation
  static const int maxProductNameLength = 100;
  static const int maxCustomerNameLength = 100;
  static const double maxPrice = 999999.99;
  static const int maxQuantity = 99999;
}
