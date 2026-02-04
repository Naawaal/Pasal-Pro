import 'package:intl/intl.dart';
import 'package:pasal_pro/core/constants/app_constants.dart';

/// Date and time formatting utilities
class DateFormatter {
  DateFormatter._();

  static final _dateFormatter = DateFormat(AppConstants.dateFormat);
  static final _dateTimeFormatter = DateFormat(AppConstants.dateTimeFormat);
  static final _displayDateFormatter = DateFormat(
    AppConstants.displayDateFormat,
  );
  static final _displayTimeFormatter = DateFormat(
    AppConstants.displayTimeFormat,
  );

  /// Format date for storage (yyyy-MM-dd)
  static String formatForStorage(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Format datetime for storage (yyyy-MM-dd HH:mm:ss)
  static String formatDateTimeForStorage(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  /// Format date for display (MMM d, yyyy)
  static String formatForDisplay(DateTime date) {
    return _displayDateFormatter.format(date);
  }

  /// Format time for display (h:mm a)
  static String formatTimeForDisplay(DateTime time) {
    return _displayTimeFormatter.format(time);
  }

  /// Format date and time for display
  static String formatDateTimeForDisplay(DateTime dateTime) {
    return '${formatForDisplay(dateTime)} ${formatTimeForDisplay(dateTime)}';
  }

  /// Parse storage format to DateTime
  static DateTime? parseStorageFormat(String dateString) {
    try {
      return _dateFormatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get today's date at midnight
  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Get relative time description (e.g., "Today", "Yesterday", "2 days ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return formatForDisplay(date);
    }
  }
}
