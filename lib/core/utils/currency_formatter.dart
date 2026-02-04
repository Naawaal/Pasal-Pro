import 'package:intl/intl.dart';
import 'package:pasal_pro/core/constants/app_constants.dart';

/// Currency formatting utilities for Nepali Rupees
class CurrencyFormatter {
  CurrencyFormatter._();

  static final _formatter = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.decimalPlaces,
    locale: 'en_NP',
  );

  static final _formatterNoSymbol = NumberFormat.currency(
    symbol: '',
    decimalDigits: AppConstants.decimalPlaces,
    locale: 'en_NP',
  );

  /// Format amount with currency symbol (e.g., "Rs 1,234.56")
  static String format(double amount) {
    return _formatter.format(amount).trim();
  }

  /// Format amount without currency symbol (e.g., "1,234.56")
  static String formatWithoutSymbol(double amount) {
    return _formatterNoSymbol.format(amount).trim();
  }

  /// Format as compact string (e.g., "1.2K", "3.4M")
  static String formatCompact(double amount) {
    final compact = NumberFormat.compact(locale: 'en_NP');
    return '${AppConstants.currencySymbol} ${compact.format(amount)}';
  }

  /// Parse currency string to double
  static double? parse(String value) {
    try {
      // Remove currency symbol and commas
      final cleaned = value
          .replaceAll(AppConstants.currencySymbol, '')
          .replaceAll(',', '')
          .trim();
      return double.parse(cleaned);
    } catch (e) {
      return null;
    }
  }

  /// Validate if string is valid currency amount
  static bool isValid(String value) {
    return parse(value) != null;
  }

  /// Calculate percentage
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }
}
