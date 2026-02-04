import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/theme/app_theme.dart';
import 'package:pasal_pro/features/products/domain/entities/product.dart';
import 'package:pasal_pro/features/products/presentation/pages/product_form_page.dart';
import 'package:pasal_pro/features/products/presentation/providers/products_providers.dart';
import 'package:pasal_pro/features/products/presentation/widgets/product_list_item.dart';

/// Products management page.
class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showInactive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsControllerProvider);
    final searchState = ref.watch(productSearchProvider);
    final products = _searchController.text.trim().isNotEmpty
        ? searchState.valueOrNull ?? []
        : productsState.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: Icon(_showInactive ? AppIcons.eyeOff : AppIcons.eye),
            tooltip: _showInactive ? 'Hide inactive' : 'Show inactive',
            onPressed: () {
              setState(() => _showInactive = !_showInactive);
              ref
                  .read(productsControllerProvider.notifier)
                  .loadProducts(includeInactive: _showInactive);
            },
          ),
          IconButton(
            icon: const Icon(AppIcons.sync),
            tooltip: 'Refresh',
            onPressed: () => ref
                .read(productsControllerProvider.notifier)
                .loadProducts(includeInactive: _showInactive),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.paddingMedium,
        child: Column(
          children: [
            _buildSearchBar(context),
            AppSpacing.medium,
            Expanded(
              child: productsState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _buildErrorState(context, error),
                data: (_) => _buildList(context, products),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(AppIcons.add),
        label: const Text('Add Product'),
        onPressed: _openCreateProduct,
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search by name, barcode, or category',
        prefixIcon: const Icon(AppIcons.search),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(AppIcons.close),
                onPressed: () {
                  setState(_searchController.clear);
                  ref.read(productSearchProvider.notifier).clear();
                },
              ),
      ),
      onChanged: (value) {
        setState(() {});
        ref.read(productSearchProvider.notifier).search(value);
      },
    );
  }

  Widget _buildList(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, index) => AppSpacing.small,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductListItem(
          product: product,
          onEdit: () => _openEditProduct(product),
          onAdjustStock: () => _showAdjustStockDialog(context, product),
          onDelete: () => _confirmDelete(context, product),
          onToggleActive: () => ref
              .read(productsControllerProvider.notifier)
              .toggleActive(product.id, !product.isActive),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.package,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          AppSpacing.medium,
          Text(
            'No products yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          AppSpacing.xSmall,
          Text(
            'Add your first product to start tracking stock and profit.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final message = error.toString();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.alertTriangle, size: 48, color: AppTheme.lossColor),
          AppSpacing.medium,
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          AppSpacing.xSmall,
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.medium,
          ElevatedButton.icon(
            icon: const Icon(AppIcons.sync),
            label: const Text('Retry'),
            onPressed: () => ref
                .read(productsControllerProvider.notifier)
                .loadProducts(includeInactive: _showInactive),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text(
          'This will deactivate ${product.name}. You can restore it later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(productsControllerProvider.notifier)
                  .deleteProduct(product.id);
            },
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateProduct() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const ProductFormPage()),
    );
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
    final controller = TextEditingController();
    bool isAdd = true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Adjust stock'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  AppSpacing.small,
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: Icon(AppIcons.package),
                    ),
                  ),
                  AppSpacing.small,
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
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
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
    if (amount <= 0) {
      _showSnack('Enter a quantity greater than zero.');
      return;
    }

    final delta = isAdd ? amount : -amount;
    await ref.read(productsControllerProvider.notifier).adjustStock(
          product.id,
          delta,
        );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
