import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/features/sales/presentation/providers/fast_sale_providers.dart';

/// Quantity input widget for adding items to cart
/// Shows when a product is selected, allows quick qty entry
class QuantityInput extends ConsumerStatefulWidget {
  const QuantityInput({super.key});

  @override
  ConsumerState<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends ConsumerState<QuantityInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToCart() {
    final selectedProduct = ref.read(selectedProductProvider);
    if (selectedProduct == null) return;

    final quantity = int.tryParse(_controller.text) ?? 1;
    if (quantity <= 0) return;

    // Add to cart
    ref.read(currentSaleProvider.notifier).addItem(selectedProduct, quantity);

    // Reset
    _controller.text = '1';
    ref.read(selectedProductProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedProduct = ref.watch(selectedProductProvider);

    if (selectedProduct == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.circular(6),
        color: AppColors.bgWhite,
      ),
      padding: AppSpacing.paddingSmall,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected product name
          Text(
            selectedProduct.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          AppSpacing.xSmall,

          // Quantity input row
          Row(
            children: [
              // Minus button
              GestureDetector(
                onTap: () {
                  final current = int.tryParse(_controller.text) ?? 1;
                  if (current > 1) {
                    _controller.text = (current - 1).toString();
                  }
                },
                child: Icon(
                  Icons.remove_circle_outline,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.hXSmall,

              // Input field
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: AppSpacing.paddingHorizontalSmall,
                    hintText: '1',
                  ),
                  onSubmitted: (_) => _addToCart(),
                ),
              ),

              // Plus button
              GestureDetector(
                onTap: () {
                  final current = int.tryParse(_controller.text) ?? 1;
                  _controller.text = (current + 1).toString();
                },
                child: Icon(
                  Icons.add_circle_outline,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          AppSpacing.xSmall,

          // Add button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _addToCart,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6),
                backgroundColor: AppColors.primaryBlue,
              ),
              child: const Text('Add', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
