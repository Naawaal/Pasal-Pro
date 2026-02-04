import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/features/sales/presentation/providers/fast_sale_providers.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/cart_item.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/quantity_input.dart';

/// Panel B: Shopping Cart
/// Displays items added to the current sale
/// Features:
/// - List of cart items with qty, price, profit
/// - Inline quantity editing
/// - Remove items
/// - Quantity input field for selected product
class CartPanel extends ConsumerWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSale = ref.watch(currentSaleProvider);
    final selectedProduct = ref.watch(selectedProductProvider);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CART',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (currentSale.isNotEmpty)
                  Text(
                    '${currentSale.totalQuantity} items',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            AppSpacing.xSmall,

            // Quantity Input (if product selected)
            if (selectedProduct != null) ...[
              const QuantityInput(),
              AppSpacing.medium,
            ],

            // Cart Items List
            Expanded(
              child: currentSale.isEmpty
                  ? Center(
                      child: Text(
                        'Cart is empty',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: currentSale.items.length,
                      separatorBuilder: (context, index) =>
                          Divider(color: AppColors.borderColor, height: 1),
                      itemBuilder: (context, index) {
                        final item = currentSale.items[index];
                        return CartItem(
                          item: item,
                          onQuantityChanged: (newQty) {
                            ref
                                .read(currentSaleProvider.notifier)
                                .updateItemQuantity(item.product.id, newQty);
                          },
                          onRemove: () {
                            ref
                                .read(currentSaleProvider.notifier)
                                .removeItem(item.product.id);
                          },
                        );
                      },
                    ),
            ),

            // Clear All Button
            if (currentSale.isNotEmpty) ...[
              AppSpacing.medium,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(currentSaleProvider.notifier).clearAll();
                  },
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('CLEAR ALL'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
