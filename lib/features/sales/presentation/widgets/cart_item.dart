import 'package:flutter/material.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/features/sales/domain/entities/sale_item.dart';

/// Individual item in the shopping cart
class CartItem extends StatefulWidget {
  final SaleItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItem({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _isHovering ? AppColors.bgLight : Colors.transparent,
        padding: AppSpacing.paddingVerticalSmall,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product name with remove button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.item.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_isHovering)
                  GestureDetector(
                    onTap: widget.onRemove,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
            AppSpacing.xSmall,

            // Quantity and subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity control
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.item.quantity > 1) {
                          widget.onQuantityChanged(widget.item.quantity - 1);
                        }
                      },
                      child: Icon(
                        Icons.remove_circle_outline,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.item.quantity}x',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        widget.onQuantityChanged(widget.item.quantity + 1);
                      },
                      child: Icon(
                        Icons.add_circle_outline,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                // Subtotal
                Text(
                  'Rs ${widget.item.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            AppSpacing.xSmall,

            // Profit indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profit:',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '+Rs ${widget.item.profit.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.successGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
