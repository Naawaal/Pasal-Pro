import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/features/dashboard/constants/dashboard_spacing.dart';
import 'package:pasal_pro/features/sales/data/models/sale_model.dart';

/// Single activity item in the recent activity feed
/// Displays sale information with payment type icon, amount, and time
class ActivityItem extends StatelessWidget {
  final SaleModel sale;

  const ActivityItem({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

    // Determine payment method colors
    final isCash = sale.paymentMethod == SalePaymentMethod.cash;
    final paymentColor = isCash
        ? AppColors.successGreen
        : AppColors.warningOrange;
    final paymentLabel = isCash ? 'Cash' : 'Credit';

    // Format time ago
    final timeLabel = _formatTimeAgo(sale.createdAt);

    return SizedBox(
      height: DashboardSpacing.activityItemHeight,
      child: Row(
        children: [
          // Payment method icon
          Container(
            width: DashboardSpacing.activityIconSize,
            height: DashboardSpacing.activityIconSize,
            decoration: BoxDecoration(
              color: paymentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Center(
              child: Icon(
                isCash ? AppIcons.cash : AppIcons.creditCard,
                size: 16.0,
                color: paymentColor,
              ),
            ),
          ),
          SizedBox(width: 12.0),

          // Action + details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sale completed',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  '${sale.items.length} items • $paymentLabel payment',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: textSecondary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Amount + time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                CurrencyFormatter.format(sale.subtotal),
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: paymentColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 2.0),
              Text(
                timeLabel,
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400,
                  color: textSecondary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Format time difference as human-readable string
  /// Returns "Just now", "5m ago", "2h ago", or date format
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(dateTime);
    }
  }
}
