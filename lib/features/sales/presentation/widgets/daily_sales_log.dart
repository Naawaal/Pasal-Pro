import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/features/sales/presentation/providers/fast_sale_providers.dart';

/// Daily Sales Log widget - displays today's sales entries and totals
class DailySalesLog extends ConsumerWidget {
  const DailySalesLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSale = ref.watch(currentSaleProvider);

    return Card(
      child: Padding(
        padding: AppSpacing.paddingMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with entry count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TODAY\'S SALES',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.primaryBlue, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${currentSale.items.length} entries',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.medium,

            // Table header and content
            Expanded(
              child: Column(
                children: [
                  // Column headers
                  Container(
                    padding: AppSpacing.paddingSmall,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Product',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Qty',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Price',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Profit',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.successGreen,
                                ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 32),
                      ],
                    ),
                  ),
                  AppSpacing.small,

                  // Sales entries list or empty state
                  if (currentSale.items.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          'No sales recorded yet',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[400]),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: currentSale.items.length,
                        separatorBuilder: (context, index) =>
                            Divider(color: Colors.grey[200], height: 1),
                        itemBuilder: (context, index) {
                          final item = currentSale.items[index];
                          return Padding(
                            padding: AppSpacing.paddingSmall,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.product.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${item.quantity}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Rs ${item.unitPrice.toStringAsFixed(2)}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Rs ${item.profit.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.successGreen,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(
                                  width: 32,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () {
                                      ref
                                          .read(currentSaleProvider.notifier)
                                          .removeItem(item.product.id);
                                    },
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            AppSpacing.medium,

            // Totals section
            Container(
              padding: AppSpacing.paddingMedium,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Column(
                children: [
                  // Total sales
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Sales',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Rs ${currentSale.subtotal.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.small,

                  // Total profit (highlighted)
                  Container(
                    padding: AppSpacing.paddingSmall,
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.successGreen,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Profit',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.successGreen,
                              ),
                        ),
                        Text(
                          'Rs ${currentSale.totalProfit.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.successGreen,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
