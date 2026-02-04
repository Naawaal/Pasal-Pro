import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/features/sales/domain/entities/sale.dart';
import 'package:pasal_pro/features/sales/presentation/providers/fast_sale_providers.dart';

/// Panel C: Totals & Payment
/// Displays:
/// - Subtotal
/// - Total profit (with profit margin %)
/// - Payment method selection (Cash/Credit)
/// - Save & Print button
class TotalsPanel extends ConsumerWidget {
  const TotalsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSale = ref.watch(currentSaleProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: AppSpacing.paddingMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'TOTALS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.medium,

            // Subtotal
            _TotalRow(
              label: 'Subtotal:',
              value: 'Rs ${currentSale.subtotal.toStringAsFixed(2)}',
              context: context,
            ),
            AppSpacing.small,

            // Profit Chip (Large, Green)
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingMedium,
              decoration: BoxDecoration(
                color: AppColors.successGreen.withValues(alpha: 0.1),
                border: Border.all(color: AppColors.successGreen),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profit',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.xSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '+Rs ${currentSale.totalProfit.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.successGreen,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        '${currentSale.averageMargin.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.successGreen,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.medium,

            // Total
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingMedium,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                border: Border.all(color: AppColors.primaryBlue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.xSmall,
                  Text(
                    'Rs ${currentSale.subtotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.large,

            // Payment Method Selection
            Text(
              'PAYMENT METHOD',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.small,

            Column(
              children: [
                _PaymentMethodOption(
                  label: 'Cash',
                  isSelected: currentSale.paymentMethod == PaymentMethod.cash,
                  onTap: () {
                    ref
                        .read(currentSaleProvider.notifier)
                        .setPaymentMethod(PaymentMethod.cash);
                  },
                ),
                AppSpacing.xSmall,
                _PaymentMethodOption(
                  label: 'Credit',
                  isSelected: currentSale.paymentMethod == PaymentMethod.credit,
                  onTap: () {
                    ref
                        .read(currentSaleProvider.notifier)
                        .setPaymentMethod(PaymentMethod.credit);
                  },
                ),
              ],
            ),
            AppSpacing.large,

            // Save & Print Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: currentSale.isEmpty
                    ? null
                    : () {
                        // TODO: Implement save & print
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sale saved! (coming soon)'),
                          ),
                        );
                      },
                icon: const Icon(Icons.save),
                label: const Text('SAVE & PRINT'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppColors.primaryBlue,
                  disabledBackgroundColor: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single total row (label + value)
class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const _TotalRow({
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Payment method option (radio button style)
class _PaymentMethodOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingSmall,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
          color: isSelected
              ? AppColors.primaryBlue.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.borderColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: isSelected
                    ? Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryBlue,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            AppSpacing.hSmall,
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
