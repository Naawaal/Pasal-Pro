import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/presentation/pages/customer_transactions_page.dart';

/// Customer list item widget for displaying customer information in list using Mix
class CustomerListItem extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;

  const CustomerListItem({super.key, required this.customer, this.onTap});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final surfaceHover = PasalColorToken.surfaceHover.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

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

    return PressableBox(
      onPress: onTap,
      style: BoxStyler()
          .marginBottom(8.0)
          .paddingX(16.0)
          .paddingY(12.0)
          .borderRounded(12.0)
          .color(surfaceColor)
          .borderAll(color: borderColor)
          .onHovered(BoxStyler().color(surfaceHover)),
      child: Row(
        children: [
          // Avatar
          Box(
            style: BoxStyler()
                .width(40)
                .height(40)
                .borderRounded(20.0)
                .color(statusColor.withValues(alpha: 0.2)),
            child: StyledIcon(
              icon: customer.isOverCreditLimit
                  ? LucideIcons.triangleAlert
                  : LucideIcons.user,
              style: IconStyler().size(20).color(statusColor),
            ),
          ),
          const SizedBox(width: 12),
          // Customer details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  customer.name,
                  style: TextStyler()
                      .fontWeight(FontWeight.w600)
                      .color(textPrimary),
                ),
                AppSpacing.xSmall,
                Row(
                  children: [
                    StyledIcon(
                      icon: LucideIcons.phone,
                      style: IconStyler().size(14).color(textSecondary),
                    ),
                    AppSpacing.hXSmall,
                    StyledText(
                      customer.phone ?? 'No phone',
                      style: TextStyler().fontSize(12).color(textSecondary),
                    ),
                  ],
                ),
                AppSpacing.xSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyledText(
                      'Purchases: Rs. ${customer.totalPurchases.toStringAsFixed(0)}',
                      style: TextStyler().fontSize(12).color(textSecondary),
                    ),
                    Box(
                      style: BoxStyler()
                          .paddingX(8.0)
                          .paddingY(4.0)
                          .borderRounded(6.0)
                          .color(statusColor.withValues(alpha: 0.1))
                          .borderAll(color: statusColor.withValues(alpha: 0.3)),
                      child: StyledText(
                        statusLabel,
                        style: TextStyler()
                            .fontSize(11)
                            .fontWeight(FontWeight.w500)
                            .color(statusColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Menu button
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'transactions') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CustomerTransactionsPage(customer: customer),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'transactions',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(AppIcons.history, size: 18),
                    AppSpacing.hSmall,
                    const Text('View Transactions'),
                  ],
                ),
              ),
            ],
            child: StyledIcon(
              icon: AppIcons.moreVertical,
              style: IconStyler().size(20).color(textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
