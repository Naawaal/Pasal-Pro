import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';

/// Customer list item widget for displaying customer information in list
class CustomerListItem extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;

  const CustomerListItem({super.key, required this.customer, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Determine status color based on customer balance
    Color statusColor = Colors.grey;
    String statusLabel = 'Settled';

    if (customer.hasBalance) {
      statusColor = Colors.orange;
      statusLabel = 'Due: Rs. ${customer.balance.toStringAsFixed(0)}';
    }

    if (customer.isOverCreditLimit) {
      statusColor = Colors.red;
      statusLabel =
          'Over Limit: Rs. ${(customer.balance - customer.creditLimit).toStringAsFixed(0)}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.2),
          child: Icon(
            customer.isOverCreditLimit
                ? LucideIcons.triangleAlert
                : LucideIcons.user,
            color: statusColor,
            size: 20,
          ),
        ),
        title: Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.xSmall,
            Row(
              children: [
                Icon(LucideIcons.phone, size: 14, color: Colors.grey[600]),
                AppSpacing.hXSmall,
                Text(
                  customer.phone ?? 'No phone',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            AppSpacing.xSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Purchases: Rs. ${customer.totalPurchases.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
                Chip(
                  label: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: statusColor.withValues(alpha: 0.1),
                  side: BorderSide(color: statusColor.withValues(alpha: 0.3)),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
        trailing: Icon(
          LucideIcons.chevronRight,
          color: Colors.grey[400],
          size: 20,
        ),
      ),
    );
  }
}
