import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/sales/presentation/providers/fast_sale_providers.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/sales_log_row.dart';

/// Daily Sales Log widget - displays today's sales entries and totals
///
/// Features:
/// - 52px data-dense rows with hover effects
/// - 150ms hover animation (scale + background)
/// - Smooth add/remove animations
/// - SalesSpacing constants throughout
/// - Green profit highlighting
class DailySalesLog extends ConsumerWidget {
  const DailySalesLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Resolve color tokens from Mix theme
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

    final currentSale = ref.watch(currentSaleProvider);

    return Padding(
      padding: SalesSpacing.getFormPadding(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with entry count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TODAY\'S SALES',
                  style: TextStyle(
                    fontSize: SalesSpacing.logHeaderFontSize,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: PasalColorToken.primary.token
                        .resolve(context)
                        .withValues(alpha: 0.1),
                    border: Border.all(
                      color: PasalColorToken.primary.token.resolve(context),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      SalesSpacing.inputBorderRadius,
                    ),
                  ),
                  child: Text(
                    '${currentSale.items.length} entries',
                    style: TextStyle(
                      fontSize: SalesSpacing.fieldLabelFontSize,
                      fontWeight: FontWeight.w600,
                      color: PasalColorToken.primary.token.resolve(context),
                    ),
                  ),
                ),
              ],
            ),
            SalesSpacing.medium,

            // Table header and content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Column headers (table-like)
                Container(
                  padding: SalesSpacing.getLogCellPadding(),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                    borderRadius: BorderRadius.circular(
                      SalesSpacing.logBorderRadius,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Product (flex: 3)
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Product',
                          style: TextStyle(
                            fontSize: SalesSpacing.logHeaderFontSize,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                      ),

                      // Qty (flex: 1)
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Qty',
                          style: TextStyle(
                            fontSize: SalesSpacing.logHeaderFontSize,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Price (flex: 1)
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Price',
                          style: TextStyle(
                            fontSize: SalesSpacing.logHeaderFontSize,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),

                      // Profit (flex: 1)
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Profit',
                          style: TextStyle(
                            fontSize: SalesSpacing.logHeaderFontSize,
                            fontWeight: FontWeight.w600,
                            color: AppColors.successGreen,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),

                      // Remove button (32px)
                      SizedBox(width: SalesSpacing.removeButtonSize),
                    ],
                  ),
                ),
                SalesSpacing.small,

                // Sales entries list or empty state
                if (currentSale.items.isEmpty)
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'No sales recorded yet',
                        style: TextStyle(
                          fontSize: SalesSpacing.fieldHintFontSize,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  )
                else
                  Flexible(
                    fit: FlexFit.loose,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: currentSale.items.length,
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.grey[200], height: 1),
                      itemBuilder: (context, index) {
                        final item = currentSale.items[index];
                        return SalesLogRow(
                          item: item,
                          index: index,
                          onRemove: () {
                            ref
                                .read(currentSaleProvider.notifier)
                                .removeItem(item.product.id);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),

            SalesSpacing.medium,

            // Totals section
            Container(
              padding: SalesSpacing.getProfitBoxPadding(),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                borderRadius: BorderRadius.circular(
                  SalesSpacing.inputBorderRadius,
                ),
              ),
              child: Column(
                children: [
                  // Total sales row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Sales',
                        style: TextStyle(
                          fontSize: SalesSpacing.totalsFontSize,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      Text(
                        'Rs ${currentSale.subtotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: SalesSpacing.totalsFontSize,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SalesSpacing.small,

                  // Total profit (highlighted green box)
                  Container(
                    padding: SalesSpacing.getInputFieldPadding(),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.successGreen,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        SalesSpacing.inputBorderRadius - 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Profit',
                          style: TextStyle(
                            fontSize: SalesSpacing.totalsFontSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.successGreen,
                          ),
                        ),
                        Text(
                          'Rs ${currentSale.totalProfit.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: SalesSpacing.profitBoxFontSize * 0.75,
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
