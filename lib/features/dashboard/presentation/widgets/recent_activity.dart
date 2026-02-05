import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:pasal_pro/features/sales/data/models/sale_model.dart';

/// Recent activity feed showing latest transactions with real data using Mix
class RecentActivity extends ConsumerWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentActivityAsync = ref.watch(recentActivityProvider);
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);

    return Box(
      style: BoxStyler()
          .paddingAll(20.0)
          .borderRounded(12.0)
          .color(surfaceColor)
          .borderAll(color: borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText(
                'Recent Activity',
                style: TextStyler()
                    .fontSize(16)
                    .fontWeight(FontWeight.w600)
                    .color(textPrimary),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: recentActivityAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: PasalColorToken.primary.token.resolve(context),
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 40,
                      color: PasalColorToken.error.token.resolve(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load activity',
                      style: TextStyle(
                        color: PasalColorToken.error.token.resolve(context),
                      ),
                    ),
                  ],
                ),
              ),
              data: (activities) {
                if (activities.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 40, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'No activity yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: activities.length,
                  separatorBuilder: (context, index) => Divider(
                    color: PasalColorToken.border.token.resolve(context),
                    height: 16,
                  ),
                  itemBuilder: (context, index) =>
                      _buildActivityItem(context, activities[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, SaleModel sale) {
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final profitColor = Color(0xFF4CAF50);
    final creditColor = Color(0xFFFF9800);

    final paymentLabel = sale.paymentMethod == SalePaymentMethod.cash
        ? 'Cash'
        : 'Credit';
    final now = DateTime.now();
    final difference = now.difference(sale.createdAt);
    String timeLabel;
    if (difference.inMinutes < 1) {
      timeLabel = 'Just now';
    } else if (difference.inMinutes < 60) {
      timeLabel = '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      timeLabel = '${difference.inHours}h ago';
    } else {
      timeLabel = DateFormat('MMM d, HH:mm').format(sale.createdAt);
    }

    return Row(
      children: [
        Box(
          style: BoxStyler()
              .width(40)
              .height(40)
              .borderRounded(10.0)
              .color(
                sale.paymentMethod == SalePaymentMethod.cash
                    ? profitColor.withValues(alpha: 0.1)
                    : creditColor.withValues(alpha: 0.1),
              ),
          child: StyledIcon(
            icon: sale.paymentMethod == SalePaymentMethod.cash
                ? Icons.attach_money
                : Icons.credit_card,
            style: IconStyler()
                .size(20)
                .color(
                  sale.paymentMethod == SalePaymentMethod.cash
                      ? profitColor
                      : creditColor,
                ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledText(
                'Sale completed',
                style: TextStyler()
                    .fontSize(14)
                    .fontWeight(FontWeight.w600)
                    .color(textPrimary),
              ),
              const SizedBox(height: 2),
              StyledText(
                '${sale.items.length} items • $paymentLabel payment',
                style: TextStyler().fontSize(12).color(textSecondary),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StyledText(
              CurrencyFormatter.format(sale.subtotal),
              style: TextStyler()
                  .fontSize(14)
                  .fontWeight(FontWeight.w600)
                  .color(profitColor),
            ),
            const SizedBox(height: 2),
            StyledText(
              timeLabel,
              style: TextStyler().fontSize(11).color(textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}


