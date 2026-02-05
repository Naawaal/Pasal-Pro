import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/presentation/pages/product_form_page.dart';
import 'package:pasal_pro/features/products/presentation/providers/products_providers.dart';
import 'package:pasal_pro/features/products/presentation/widgets/product_list_item.dart';

/// Modern Products Page with beautiful flat design
class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showInactive = false;
  bool _showLowStockOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Resolve Mix design tokens once per build
    final bgColor = PasalColorToken.background.token.resolve(context);
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final primaryLight = primaryColor.withValues(alpha: 0.1);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final errorColor = PasalColorToken.error.token.resolve(context);
    final errorLight = errorColor.withValues(alpha: 0.1);

    final productsState = ref.watch(productsControllerProvider);
    final searchState = ref.watch(productSearchProvider);
    final sourceProducts = _searchController.text.trim().isNotEmpty
        ? searchState.valueOrNull ?? []
        : productsState.valueOrNull ?? [];
    final products = _applyFilters(sourceProducts);

    return Container(
      color: bgColor,
      padding: AppResponsive.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with stats
          _buildHeader(
            context,
            products,
            primaryColor: primaryColor,
            primaryLight: primaryLight,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          SizedBox(height: AppResponsive.getSectionGap(context)),

          // Search and filters
          _buildSearchAndFilters(
            context,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            primaryColor: primaryColor,
            primaryLight: primaryLight,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          SizedBox(height: AppResponsive.getSectionGap(context) - 8),

          // Products list
          Expanded(
            child: productsState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _buildErrorState(
                context,
                error,
                errorColor: errorColor,
                errorLight: errorLight,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              data: (_) => _buildProductsList(
                context,
                products,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryColor: primaryColor,
                primaryLight: primaryLight,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    List<Product> products, {
    required Color primaryColor,
    required Color primaryLight,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final totalProducts = products.length;
    final lowStockCount = products.where((p) => p.isLowStock).length;
    final inventoryValue = products.fold<double>(
      0,
      (sum, p) => sum + (p.sellingPrice * p.stockPieces),
    );

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.inventory_2_outlined, color: primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$totalProducts items${lowStockCount > 0 ? " • $lowStockCount low stock" : ""} • ${CurrencyFormatter.formatCompact(inventoryValue)} value',
                style: TextStyle(fontSize: 13, color: textSecondary),
              ),
            ],
          ),
        ),
        _buildActionButton(
          context,
          icon: Icons.add,
          label: 'Add Product',
          primaryColor: primaryColor,
          onPressed: _openCreateProduct,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color primaryColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSearchAndFilters(
    BuildContext context, {
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryColor,
    required Color primaryLight,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: textSecondary),
                prefixIcon: Icon(Icons.search, color: textSecondary, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {});
                ref.read(productSearchProvider.notifier).search(value);
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildFilterChip(
          context,
          label: 'Low Stock',
          selected: _showLowStockOnly,
          primaryColor: primaryColor,
          primaryLight: primaryLight,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textPrimary: textPrimary,
          onSelected: (value) => setState(() => _showLowStockOnly = value),
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          context,
          label: 'Inactive',
          selected: _showInactive,
          primaryColor: primaryColor,
          primaryLight: primaryLight,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textPrimary: textPrimary,
          onSelected: (value) {
            setState(() => _showInactive = value);
            ref
                .read(productsControllerProvider.notifier)
                .loadProducts(includeInactive: _showInactive);
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required Color primaryColor,
    required Color primaryLight,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required ValueChanged<bool> onSelected,
  }) {
    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primaryLight : surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? primaryColor : borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? primaryColor : textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList(
    BuildContext context,
    List<Product> products, {
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryColor,
    required Color primaryLight,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add your first product to get started',
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ListView.separated(
        padding: EdgeInsets.all(AppResponsive.getSectionGap(context) - 4),
        itemCount: products.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: AppResponsive.getSectionGap(context) - 4),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductListItem(
            product: product,
            onEdit: () => _openEditProduct(product),
            onAdjustStock: () => _showAdjustStockDialog(context, product),
            onToggleActive: () => ref
                .read(productsControllerProvider.notifier)
                .toggleActive(product.id, !product.isActive),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    Object error, {
    required Color errorLight,
    required Color errorColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: errorLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.error_outline, size: 48, color: errorColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            error.toString(),
            style: TextStyle(fontSize: 13, color: textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Product> _applyFilters(List<Product> products) {
    var filtered = products;
    if (!_showInactive) {
      filtered = filtered.where((p) => p.isActive).toList();
    }
    if (_showLowStockOnly) {
      filtered = filtered.where((p) => p.isLowStock).toList();
    }
    return filtered;
  }

  Future<void> _openCreateProduct() async {
    final created = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const ProductFormPage()));
    if (created == true && mounted) {
      ref
          .read(productsControllerProvider.notifier)
          .loadProducts(includeInactive: _showInactive);
    }
  }

  Future<void> _openEditProduct(Product product) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ProductFormPage(product: product)),
    );
    if (updated == true && mounted) {
      ref
          .read(productsControllerProvider.notifier)
          .loadProducts(includeInactive: _showInactive);
    }
  }

  Future<void> _showAdjustStockDialog(
    BuildContext context,
    Product product,
  ) async {
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final controller = TextEditingController();
    bool isAdd = true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text('Adjust Stock'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: const Icon(AppIcons.package),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(
                        value: true,
                        label: Text('Add'),
                        icon: Icon(AppIcons.packagePlus),
                      ),
                      ButtonSegment<bool>(
                        value: false,
                        label: Text('Remove'),
                        icon: Icon(AppIcons.packageMinus),
                      ),
                    ],
                    selected: {isAdd},
                    onSelectionChanged: (value) {
                      setDialogState(() => isAdd = value.first);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) {
      controller.dispose();
      return;
    }

    final amount = int.tryParse(controller.text.trim()) ?? 0;
    controller.dispose();
    if (amount <= 0) return;

    final delta = isAdd ? amount : -amount;
    await ref
        .read(productsControllerProvider.notifier)
        .adjustStock(product.id, delta);
  }
}
