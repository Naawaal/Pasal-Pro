import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/sales/presentation/providers/fast_sale_providers.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/product_search_item.dart';

/// Panel A: Product Search & List
/// Modern flat design - inspired by Linear's search interface
class SearchPanel extends ConsumerStatefulWidget {
  const SearchPanel({super.key});

  @override
  ConsumerState<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends ConsumerState<SearchPanel> {
  late final TextEditingController _searchController;
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _handleProductSelect(Product product) {
    ref.read(selectedProductProvider.notifier).state = product;
    ref.read(recentProductsProvider.notifier).addRecent(product);
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = ref.watch(filteredProductsProvider);
    final recentProducts = ref.watch(recentProductsProvider);

    return Container(
      decoration: BoxDecoration(
        color: PasalColorToken.surface.token.resolve(context),
        border: Border.all(
          color: PasalColorToken.border.token.resolve(context),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar - Borderless modern style
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: PasalColorToken.surfaceAlt.token.resolve(context),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
              decoration: const InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: AppColors.textTertiary),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: TextStyle(
                color: PasalColorToken.textPrimary.token.resolve(context),
              ),
            ),
          ),

          // Recent Products - Horizontal chips
          if (recentProducts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'RECENT',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recentProducts.length,
                itemBuilder: (context, index) {
                  final product = recentProducts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _handleProductSelect(product),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Products List
          Expanded(
            child: filteredProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(color: AppColors.textTertiary),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductSearchItem(
                      product: product,
                      onTap: _handleProductSelect,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: TextStyle(color: AppColors.dangerRed),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
